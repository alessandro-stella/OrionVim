local M = {}

local function get_hypr_border_color()
	local path = os.getenv("HOME") .. "/.config/hypr/dynamic-border.conf"
	local file = io.open(path, "r")
	if not file then
		return nil
	end

	local color
	for line in file:lines() do
		local match = line:match("rgba%((%x%x%x%x%x%x)")
		if match then
			color = "#" .. match
			break
		end
	end

	file:close()
	return color
end

function M.setup()
	local border_color = get_hypr_border_color() or "#FFFFFF"

	local foreground = {
		"FloatBorder",
		"TelescopeBorder",
		"TelescopePromptBorder",
		"TelescopePromptPrefix",
		"TelescopePreviewBorder",
		"TelescopeResultsBorder",
		"SagaTitle",
		"WinSeparator",
		"DashboardHeader",
		"BlinkCmpDocBorder",
		"BlinkCmpMenuBorder",
		"BlinkCmpSignatureHelpBorder",
	}

	local background = {
		"PmenuThumb",
	}

	for _, group in ipairs(foreground) do
		vim.api.nvim_set_hl(0, group, { fg = border_color, bg = "NONE" })
	end

	for _, group in ipairs(background) do
		vim.api.nvim_set_hl(0, group, { bg = border_color })
	end

	vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#313244", fg = border_color, bold = true })
end

return M
