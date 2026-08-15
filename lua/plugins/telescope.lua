return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
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
				horizontal = {
					preview_width = 0.5,
				},
			},
		},
		pickers = {
			find_files = {
				follow = true,
			},
			live_grep = {
				additional_args = function()
					return { "--follow" }
				end,
			},
		},
		extensions = {
			fzf = {},
		},
	},
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
		telescope.load_extension("fzf")
	end,
}
