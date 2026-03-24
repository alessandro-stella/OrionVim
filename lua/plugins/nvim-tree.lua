return {
	"nvim-tree/nvim-tree.lua",
	opts = {
		git = {
			enable = true,
		},
		renderer = {
			root_folder_label = false,
			indent_markers = {
				enable = true,
			},
			highlight_git = true,
			icons = {
				show = {
					git = true,
				},
			},
		},
		view = {
			side = "right",
		},
	},
}
