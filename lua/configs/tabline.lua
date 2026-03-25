local function tabline()
	local s = ""
	local bufs = vim.fn.getbufinfo({ buflisted = 1 })
	local current = vim.api.nvim_get_current_buf()
	local has_devicons, devicons = pcall(require, "nvim-web-devicons")

	for i, buf in ipairs(bufs) do
		local bufnr = buf.bufnr
		local full_name = vim.fn.fnamemodify(buf.name, ":t")

		if full_name == "" then
			full_name = "[No Name]"
		end

		-- Limit buffer name
		local name = full_name
		local max_len = 30

		if #full_name > max_len then
			local extension = vim.fn.fnamemodify(full_name, ":e")
			local stem = vim.fn.fnamemodify(full_name, ":r")

			if extension ~= "" then
				local allowed_stem_len = max_len - #extension - 2
				name = string.sub(stem, 1, allowed_stem_len) .. "…" .. "." .. extension
			else
				name = string.sub(full_name, 1, max_len - 1) .. "…"
			end
		end

		-- Add special highlight if buffer is currently selected
		local is_sel = (bufnr == current)
		local hl_group = is_sel and "%#TabLineSel#" or "%#TabLineTextInactive#"

		-- Add dot for modified buffers
		local modified_dot = ""
		if vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
			modified_dot = is_sel and " %#TabModifiedActive#●" or " %#TabModifiedInactive#●"
		end

		-- Setup buffer icon
		local icon, icon_hl = "", ""
		if has_devicons then
			local ic, hl = devicons.get_icon(full_name, vim.fn.fnamemodify(full_name, ":e"), { default = true })
			icon = ic .. " "
			if is_sel then
				icon_hl = "%#" .. hl .. "Selected#"
			else
				icon_hl = "%#TabLineTextInactive#"
			end
		end

		-- Change style if buffer is selected
		local click = "%" .. bufnr .. "@v:lua.switch_buffer@"
		s = s .. click

		if i == 1 then
			s = s .. hl_group .. " "
		else
			if is_sel then
				s = s .. "%#TabSeparatorSel#⎸"
			else
				s = s .. "%#TabSeparator#⎸"
			end
		end

		-- Build final buffer name
		s = s .. icon_hl .. icon .. hl_group .. name .. modified_dot .. " "

		if i == #bufs then
			s = s .. "%#TabSeparator#⎸"
		end

		s = s .. "%X"
	end

	s = s .. "%#TabLineFill#%="

	-- Add root folder name on top of Treesitter
	local nvim_tree_width = 0
	local wins = vim.api.nvim_tabpage_list_wins(0)
	for _, win in ipairs(wins) do
		local b = vim.api.nvim_win_get_buf(win)
		if vim.bo[b].filetype == "NvimTree" then
			nvim_tree_width = vim.api.nvim_win_get_width(win)
			break
		end
	end

	if nvim_tree_width > 0 then
		local root_name = "   " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " "
		s = s .. "%#WinSeparator#│%#NvimTreeNormal#" .. root_name
		local padding = nvim_tree_width - vim.fn.strdisplaywidth(root_name)
		if padding > 0 then
			s = s .. string.rep(" ", padding)
		end
	end

	return s
end

_G.switch_buffer = function(bufnr, _, _, _)
	vim.api.nvim_set_current_buf(bufnr)
end

_G.render_tabline = tabline
vim.opt.tabline = "%!v:lua.render_tabline()"
vim.opt.mouse = "a"

local colors = {
	not_selected = "#6f737b",
	red = "#e06c75",
	green = "#98c379",
}

vim.api.nvim_set_hl(0, "TabSeparator", { fg = colors.not_selected, bg = "NONE", underline = false })
vim.api.nvim_set_hl(0, "TabLineTextInactive", { fg = colors.not_selected, bg = "NONE", underline = false })
vim.api.nvim_set_hl(0, "TabLineSel", { bg = "NONE", underline = true, sp = colors.not_selected })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
vim.api.nvim_set_hl(
	0,
	"TabModifiedActive",
	{ fg = colors.green, bg = "NONE", underline = true, sp = colors.not_selected }
)
vim.api.nvim_set_hl(0, "TabModifiedInactive", { fg = colors.red, bg = "NONE", underline = false })
vim.api.nvim_set_hl(0, "TabSeparatorSel", { fg = colors.not_selected, underline = true, sp = colors.not_selected })

-- Create selected icons style
local has_devicons, devicons = pcall(require, "nvim-web-devicons")
if has_devicons then
	for _, data in pairs(devicons.get_icons()) do
		local hl = "DevIcon" .. data.name
		local hl_data = vim.api.nvim_get_hl(0, { name = hl })

		if hl_data and hl_data.fg then
			vim.api.nvim_set_hl(0, hl .. "Selected", {
				fg = string.format("#%06x", hl_data.fg),
				bg = "NONE",
				underline = true,
				sp = colors.not_selected,
			})
		end
	end
end
