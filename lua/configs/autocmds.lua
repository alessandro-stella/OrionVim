-- Change tab from spaces to actual tab for text files
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "text", "conf", "markdown", "" },
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 0
	end,
})

-- Tmux integration
local function tmux_check_and_set(show)
	if not vim.env.TMUX then
		return
	end

	local status = show and "on" or "off"
	os.execute("tmux set status " .. status)
end

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		tmux_check_and_set(false)
	end,
})

vim.api.nvim_create_autocmd("VimSuspend", {
	callback = function()
		tmux_check_and_set(true)
	end,
})

vim.api.nvim_create_autocmd("VimResume", {
	callback = function()
		tmux_check_and_set(false)
	end,
})

-- Setup after LSP loading
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")

		map("K", function()
			vim.lsp.buf.hover({ border = "rounded" })
		end, "Hover Documentation")

		map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
		map("<leader>lf", vim.lsp.buf.format, "Format")

		local function client_supports_method(client, method, bufnr)
			if vim.fn.has("nvim-0.11") == 1 then
				return client:supports_method(method, bufnr)
			else
				return client.supports_method(method, { bufnr = bufnr })
			end
		end

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if
			client
			and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
		then
			local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
				end,
			})
		end
	end,
})

-- Highlight yanked lines
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 150,
		})
	end,
})
