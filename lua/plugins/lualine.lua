return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	config = function()
		local function filename_with_icon()
			local name = vim.fn.expand("%:t")
			if name == "" then
				return "[No Name]"
			end

			local icon = ""
			local ok, devicons = pcall(require, "nvim-web-devicons")
			if ok then
				icon = devicons.get_icon(name, nil, { default = true }) or ""
			end

			return icon .. " " .. name
		end

		require("lualine").setup({
			options = {
				theme = "onedark",
				globalstatus = true,
				component_separators = { left = "╱", right = "" },
				section_separators = { left = "", right = "" },
			},

			sections = {
				lualine_a = {
					function()
						local mode_map = {
							n = "NORMAL",
							i = "INSERT",
							v = "VISUAL",
							V = "V-LINE",
							["\22"] = "V-BLOCK",
							c = "COMMAND",
							R = "REPLACE",
							t = "TERMINAL",
						}
						local mode = vim.api.nvim_get_mode().mode
						return " " .. (mode_map[mode] or mode)
					end,
				},
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { filename_with_icon },

				lualine_x = {
					{
						function()
							local c = vim.lsp.get_clients({ bufnr = 0 })
							if #c == 0 then
								return "No LSP"
							end
							local t = {}
							for i = 1, #c do
								t[i] = c[i].name
							end
							return "  " .. table.concat(t, ", ")
						end,
						color = { fg = "#fab387", gui = "bold" },
					},
				},

				lualine_y = {
					{
						function()
							local dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
							return " " .. dir
						end,
						color = { bg = "#3e4452", fg = "#abb2bf" },
					},
				},

				lualine_z = {
					function()
						return vim.fn.line(".") .. ":" .. vim.fn.col(".")
					end,
				},
			},
		})
	end,
}
