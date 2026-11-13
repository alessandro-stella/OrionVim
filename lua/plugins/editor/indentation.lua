return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = {
				enabled = false,
			},
			exclude = {
				filetypes = {
					"help",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"NvimTree",
				},
			},
		},
	},
	{
		"echasnovski/mini.indentscope",
		version = false,
		event = { "BufReadPre", "BufNewFile" },
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "NvimTree", "help", "Trouble", "trouble", "lazy", "mason", "notify", "toggleterm" },
				callback = function(args)
					vim.b[args.buf].miniindentscope_disable = true
				end,
			})
		end,
		opts = {
			symbol = "│",
			options = { try_as_border = true },
			draw = {
				delay = 50,
				animation = function()
					return 0
				end,
			},
		},
	},
}
