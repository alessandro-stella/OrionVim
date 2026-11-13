return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	opts = {
		-- Qui definiamo o sovrascriviamo i formattatori custom
		formatters = {
			forge_fmt = {
				command = "forge",
				args = { "fmt", "--stdin" },
			},
		},

		-- Qui li assegniamo ai vari linguaggi
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

		-- Regole per il salvataggio automatico
		format_on_save = {
			timeout_ms = 1000,
			lsp_fallback = true,
		},
	},
}
