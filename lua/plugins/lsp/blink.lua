return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets", "navarasu/onedark.nvim" },
	version = "*",
	config = function()
		require("blink.cmp").setup({
			enabled = function()
				local disable_filetypes =
					{ sagarename = true, prolog = true, text = true, conf = true, markdown = true }
				return not disable_filetypes[vim.bo.filetype]
			end,
			signature = {
				enabled = true,
				window = {
					border = "rounded",
					winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
				},
			},
			appearance = { use_nvim_cmp_as_default = false, nerd_font_variant = "normal" },
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					cmdline = { min_keyword_length = 2 },
				},
			},
			keymap = { preset = "default", ["<CR>"] = { "accept", "fallback" } },
			completion = {
				menu = {
					border = "rounded",
					draw = { columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } } },
				},
				documentation = { auto_show = false, window = { border = "rounded" } },
			},
			fuzzy = { implementation = "lua" },
		})

		local highlights = { "Pmenu", "NormalFloat" }
		for _, group in ipairs(highlights) do
			vim.api.nvim_set_hl(0, group, { bg = "NONE" })
		end
	end,
}
