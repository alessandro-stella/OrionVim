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
		on_attach = function(bufnr)
			local api = require("nvim-tree.api")

			-- mantieni i mapping di default
			api.config.mappings.default_on_attach(bufnr)

			-- vertical split a destra con v
			local function open_vsplit()
				vim.cmd("wincmd l") -- sposta il focus alla finestra principale
				api.node.open.vertical()
			end

			-- horizontal split con h
			local function open_hsplit()
				vim.cmd("wincmd l") -- sposta il focus alla finestra principale
				api.node.open.horizontal()
			end

			vim.keymap.set("n", "v", open_vsplit, { buffer = bufnr, desc = "Open: Vertical Split" })
			vim.keymap.set("n", "h", open_hsplit, { buffer = bufnr, desc = "Open: Horizontal Split" })
		end,
	},
}
