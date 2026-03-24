return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"prismals",
					"clangd",
					"pyright",
					"vtsls",
					"lua_ls",
					"cssls",
					"eslint",
					"html",
					"jsonls",
					"tailwindcss",
					"jdtls",
				},
				automatic_installation = true,
				automatic_enable = {
					exclude = {
						"jdtls",
					},
				},
			})
		end,
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"codelldb",
					"shellcheck",
					"shfmt",
					"solang",
					"stylua",
				},
				auto_update = true,
				run_on_start = true,
				start_delay = 1000,
			})
		end,
	},
}
