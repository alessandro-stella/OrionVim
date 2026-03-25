return {
	{ "L3MON4D3/LuaSnip", keys = {} },
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"navarasu/onedark.nvim", -- Force theme loading before this to not override highlights
		},
		version = "*",
		config = function()
			require("blink.cmp").setup({
				enabled = function()
					-- Disable for Lspsaga rename
					if vim.bo.filetype == "sagarename" then
						return false
					end
					return true
				end,
				signature = {
					enabled = true,
					window = {
						border = "rounded",
						winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
					},
				},
				appearance = {
					use_nvim_cmp_as_default = false,
					nerd_font_variant = "normal",
				},
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
					providers = {
						cmdline = {
							min_keyword_length = 2,
						},
					},
				},
				keymap = {
					preset = "default",
					["<CR>"] = { "accept", "fallback" },
				},
				completion = {
					menu = {
						border = "rounded",
						draw = {
							columns = {
								{ "kind_icon" },
								{ "label", "label_description", gap = 1 },
								{ "kind" },
							},
						},
					},
					documentation = {
						auto_show = false,
						window = {
							border = "rounded",
						},
					},
				},
				fuzzy = { implementation = "lua" },
			})

			require("luasnip.loaders.from_vscode").lazy_load()

			local highlights = {
				"Pmenu",
				"NormalFloat",
			}

			for _, group in ipairs(highlights) do
				vim.api.nvim_set_hl(0, group, { bg = "NONE" })
			end
		end,
	},
}
