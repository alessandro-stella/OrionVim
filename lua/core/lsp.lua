-- Use custom jdtls setup
vim.lsp.config("jdtls", {
	autostart = false,
})

-- Disable duplicate messages from vtsls and eslint
vim.lsp.config("vtsls", {
	settings = {
		typescript = {
			validate = false,
		},
		javascript = {
			validate = false,
		},
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
