return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup()

		vim.keymap.set("n", "<leader>gp", "0:Gitsigns preview_hunk<CR>", { desc = "Preview changes from remote repo" })
	end,
}
