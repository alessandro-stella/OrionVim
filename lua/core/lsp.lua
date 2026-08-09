-- Use custom jdtls setup
vim.lsp.config("jdtls", {
	autostart = false,
})

-- Disable duplicate messages from vtsls and eslint
-- and enable autocompletion
vim.diagnostic.config({
	severity_sort = true,
})

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
