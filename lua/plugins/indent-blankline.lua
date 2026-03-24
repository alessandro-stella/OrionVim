return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPost", "BufNewFile" },
	main = "ibl",
	opts = {
		indent = {
			char = "▏",
			tab_char = "▏",
		},
		scope = {
			enabled = true,
			show_start = true,
			show_end = false,
		},
		exclude = {
			filetypes = {
				"help",
				"terminal",
				"lazy",
				"lspinfo",
				"TelescopePrompt",
				"TelescopeResults",
				"mason",
				"norg",
				"nvcheatsheet",
				"noop",
				"dashboard",
				"NvimTree",
			},
		},
	},
	config = function(_, opts)
		require("ibl").setup(opts)

		vim.cmd("hi @ibl.scope.underline.1 gui=underline guisp=#6b6b7c")
		vim.cmd("hi @ibl.scope.char.1 guifg=#6b6b7c")
	end,
}
