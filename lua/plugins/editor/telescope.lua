return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Telescope: Find files" },
		{ "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Telescope: Recent files" },
		{ "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Telescope: Live grep" },
	},
	opts = {
		defaults = {
			prompt_prefix = "   ",
			selection_caret = " ",
			entry_prefix = " ",
			sorting_strategy = "ascending",
			layout_strategy = "horizontal",
			layout_config = {
				prompt_position = "top",
				horizontal = { preview_width = 0.5 },
			},
		},
		pickers = {
			find_files = { follow = true },
			live_grep = {
				additional_args = function()
					return { "--follow" }
				end,
			},
		},
		extensions = { fzf = {} },
	},
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
		telescope.load_extension("fzf")
	end,
}
