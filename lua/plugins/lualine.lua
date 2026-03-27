return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	config = function()
		local function get_permissions()
			local file = vim.fn.expand("%:p")
			if file == "" or file == nil then
				return ""
			end
			local permissions = vim.fn.getfperm(file)
			return permissions ~= "" and permissions or ""
		end

		local function get_lsp_name()
			local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
			if #buf_clients == 0 then
				return "No LSP"
			end

			local client_names = {}
			for _, client in ipairs(buf_clients) do
				table.insert(client_names, client.name)
			end

			return "  " .. table.concat(client_names, ", ")
		end

		local function custom_filename()
			local full_name = vim.fn.expand("%:t")
			if full_name == "" then
				return "[No Name]"
			end

			local max_len = 30
			if #full_name > max_len then
				local extension = vim.fn.fnamemodify(full_name, ":e")
				local stem = vim.fn.fnamemodify(full_name, ":r")

				if extension ~= "" then
					local allowed_stem_len = max_len - #extension - 2
					if allowed_stem_len > 0 then
						return string.sub(stem, 1, allowed_stem_len) .. "…" .. "." .. extension
					end
				end

				return string.sub(full_name, 1, max_len - 1) .. "…"
			end
			return full_name
		end

		require("lualine").setup({
			options = {
				theme = "auto",
				globalstatus = true,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = {
					{ custom_filename, file_status = true, icons_enabled = true },
					{ get_permissions, color = { fg = "#a6adc8" } },
				},
				lualine_x = {
					{ get_lsp_name, color = { fg = "#fab387", gui = "bold" } },
					"filetype",
				},
				lualine_z = { "location" },
			},
		})
	end,
}
