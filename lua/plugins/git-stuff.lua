return {
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose" },
		keys = {
			{
				"<leader>do",
				"DiffviewOpen",
				desc = "Diffview Open",
			},
			{
				"<leader>dc",
				"DiffviewClose",
				desc = "Diffview Close",
			},
			{
				"<leader>dt",
				function()
					local diffview = require("diffview.lib")
					if next(diffview.views) == nil then
						vim.cmd("DiffviewOpen")
					else
						vim.cmd("DiffviewClose")
					end
				end,
				desc = "Toggle Diffview",
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()

			vim.keymap.set(
				"n",
				"<leader>gp",
				"0:Gitsigns preview_hunk<CR>",
				{ desc = "Preview changes from remote repo" }
			)
		end,
	},
}
