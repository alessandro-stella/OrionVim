return {
	{
		"b0o/incline.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			window = {
				margin = { vertical = 0, horizontal = 1 },
				zindex = 10,
			},
			hide = {
				cursorline = "smart",
			},
			ignore = {
				buftypes = "special",
				unlisted_buffers = true,
				filetypes = { "NvimTree", "help", "Trouble", "trouble", "lazy", "mason", "notify", "toggleterm" },
			},
			render = function(props)
				local name = vim.api.nvim_buf_get_name(props.buf)
				local filename = name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":t")
				local icon, color = require("nvim-web-devicons").get_icon_color(filename)
				local modified = vim.bo[props.buf].modified

				local background = props.focused and "#3e4452" or "#21252b"
				local fg_icon = props.focused and color or "#3e4452"
				local edit_icon = props.focused and "#e5c07b" or "#3e4452"

				return {
					{ " ", guifg = background },
					{ icon and { icon, " ", guifg = fg_icon, guibg = background } or "" },
					props.focused and { filename, gui = "bold", guibg = background }
						or { filename, guifg = "#3e4452", guibg = background },
					modified and { " ●", guifg = edit_icon, guibg = background } or "",
					{ "", guifg = background },
				}
			end,
		},
	},
}
