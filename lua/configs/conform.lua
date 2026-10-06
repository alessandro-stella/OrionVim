local options = {
	forge = {
		command = "forge",
		args = { "fmt", "--stdin" },
	},

	formatters_by_ft = {
		lua = { "stylua" },
		solidity = { "forge_fmt" },
		css = { "prettierd" },
		html = { "prettierd" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescriptreact = { "prettierd" },
	},

	format_on_save = {
		timeout_ms = 1000,
		lsp_fallback = true,
	},
}

return options
