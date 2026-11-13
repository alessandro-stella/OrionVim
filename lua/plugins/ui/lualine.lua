local MAX_DIRS = 2

local function split_path()
	local path = vim.fn.expand("%:p")
	if path == "" then
		return nil, nil
	end
	local cwd = vim.uv.cwd() or vim.fn.getcwd()
	local rel
	if path:sub(1, #cwd + 1) == cwd .. "/" then
		rel = path:sub(#cwd + 2)
	else
		rel = vim.fn.fnamemodify(path, ":~")
	end
	local parts = vim.split(rel, "/", { plain = true })
	local name = table.remove(parts)
	if #parts > MAX_DIRS then
		parts = { "…", unpack(parts, #parts - MAX_DIRS + 1) }
	end
	local dir = #parts > 0 and (table.concat(parts, "/") .. "/") or ""
	return (dir:gsub("%%", "%%%%")), (name:gsub("%%", "%%%%"))
end

local function icon_and_dir()
	local dir, name = split_path()
	if not name then
		return "[No Name]"
	end
	local icon = ""
	local ok, devicons = pcall(require, "nvim-web-devicons")
	if ok then
		icon = devicons.get_icon(name, nil, { default = true }) or ""
	end
	return icon .. " " .. dir
end

local function filename()
	local _, name = split_path()
	if not name then
		return ""
	end
	if vim.bo.readonly or not vim.bo.modifiable then
		name = name .. " " .. "󰌾"
	end
	return name
end

local secondary = {
	eslint = true,
	tailwindcss = true,
	emmet_ls = true,
	emmet_language_server = true,
	copilot = true,
	["null-ls"] = true,
	["none-ls"] = true,
	cssmodules_ls = true,
	jsonls = true,
}

local function lsp_main()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		return "No LSP"
	end
	table.sort(clients, function(a, b)
		local sa, sb = secondary[a.name] and 1 or 0, secondary[b.name] and 1 or 0
		if sa ~= sb then
			return sa < sb
		end
		return a.name < b.name
	end)
	return "  " .. clients[1].name .. (#clients > 1 and " + " .. (#clients - 1) or "")
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	config = function()
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
				lualine_c = {
					{ icon_and_dir, separator = "", padding = { left = 1, right = 0 } },
					{
						filename,
						padding = { left = 0, right = 1 },
						color = function()
							if vim.bo.modified then
								return { fg = "#e5c07b", gui = "bold,italic" }
							end
							return { gui = "bold" }
						end,
					},
				},
				lualine_x = { { lsp_main, color = { fg = "#fab387", gui = "bold" } } },
				lualine_y = {
					{
						function()
							local dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
							return " " .. dir
						end,
						color = { bg = "#3e4452", fg = "#abb2bf" },
					},
					{
						function()
							return vim.env.TMUX and "TMUX" or ""
						end,
						color = { bg = "#698dda", fg = "#212023", gui = "bold" },
						separator = { left = "" },
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
