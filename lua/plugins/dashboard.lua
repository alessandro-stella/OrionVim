return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	config = function()
		require("dashboard").setup({
			config = {
				header = {
					"  .g8\"\"8q.              db                `7MMF'   `7MF'db                    ",
					".dP'    `YM.                                `MA     ,V                        ",
					"dM'      `MM `7Mb,od8 `7MM  ,pW\"Wq.`7MMpMMMb.VM:   ,V `7MM  `7MMpMMMb.pMMMb.  ",
					"MM        MM   MM' \"'   MM 6W'   `Wb MM    MM MM.  M'   MM    MM    MM    MM  ",
					"MM.      ,MP   MM       MM 8M     M8 MM    MM `MM A'    MM    MM    MM    MM  ",
					"`Mb.    ,dP'   MM       MM YA.   ,A9 MM    MM  :MM;     MM    MM    MM    MM  ",
					" `\"bmmd\"'   .JMML.   .JMML.`Ybmd9'.JMML  JMML. VF    .JMML..JMML  JMML  JMML",
					"",
					" Powered by  eovim",
					"",
				},
				center = {
					{
						icon = "󰈔  ",
						desc = "Nuovo File",
						action = "enew",
						key = "n",
					},
				},
				packages = {
					enable = true,
					version = false, -- Hide "startuptime"
				},
				shortcut = {},
				mru = { limit = 0, enable = false },
				project = { enable = false },
				footer = {},
			},
		})
	end,
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
