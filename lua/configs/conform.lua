local options = {
	forge = {
		command = "forge",
		args = { "fmt", "--stdin" },
	},

	formatters_by_ft = {
		lua = { "stylua" },
		solidity = { "forge_fmt" },
		css = { "prettier" },
		html = { "prettier" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
	},

	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_fallback = true,
	},
}

return options
