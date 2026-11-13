return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	build = ":TSUpdate",
	lazy = false,
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"c",
				"cpp",
				"python",
				"lua",
				"html",
				"css",
				"json",
				"yaml",
				"javascript",
				"typescript",
				"java",
				"prisma",
				"bash",
				"solidity",
				"svelte",
				"vim",
				"vimdoc",
				"query",
			},
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
