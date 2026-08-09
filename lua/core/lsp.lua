-- Use custom jdtls setup
vim.lsp.config("jdtls", {
	autostart = false,
})

-- Javascript diagnostics
vim.diagnostic.config({
	severity_sort = true,
})

local default_publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]

vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
	if result and result.diagnostics then
		local client = vim.lsp.get_client_by_id(ctx.client_id)

		if client and client.name == "vtsls" then
			local bufnr = vim.uri_to_bufnr(result.uri)
			local filetype = vim.bo[bufnr].filetype

			if filetype == "javascript" or filetype == "javascriptreact" then
				result.diagnostics = vim.tbl_filter(function(diagnostic)
					return diagnostic.code ~= 80001 and diagnostic.code ~= 7044
				end, result.diagnostics)
			end
		end
	end

	default_publish_diagnostics(err, result, ctx, config)
end

vim.lsp.config("vtsls", {
	settings = {
		javascript = {
			validate = true,
			preferences = {
				includePackageJsonAutoImports = "on",
				importModuleSpecifierPreference = "relative",
			},
		},
		typescript = {
			validate = true,
			preferences = {
				includePackageJsonAutoImports = "on",
				importModuleSpecifierPreference = "relative",
			},
		},
	},
})

-- Fix for header path on NixOS
vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--query-driver=/run/current-system/sw/bin/gcc,/run/current-system/sw/bin/clang,/nix/store/*/bin/*gcc*,/nix/store/*/bin/*clang*",
	},
})

-- Custom diagnostics
vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅙 ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = "󰋼 ",
			[vim.diagnostic.severity.HINT] = "󰌵 ",
		},
	},
})
