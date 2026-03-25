local M = {}

function M.setup()
	-- Number lines
	vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#dddddd", bg = "none" })
	vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })

	-- Diagnostic
	local diag_colors = {
		Error = "#e06c75",
		Warn = "#e7c787",
		Info = "#98c379",
		Hint = "#de98fd",
		Ok = "#b3f6c0",
		Unused = "#6f737b", -- DiagnosticUnnecessary
	}

	for type, color in pairs(diag_colors) do
		local suffix = type
		if type == "Unused" then
			suffix = "Unnecessary"
		end

		vim.api.nvim_set_hl(0, "DiagnosticVirtualText" .. suffix, { fg = color, bg = "NONE" })
		vim.api.nvim_set_hl(0, "DiagnosticSign" .. suffix, { fg = color, bg = "NONE" })
		vim.api.nvim_set_hl(0, "DiagnosticFloating" .. suffix, { fg = color, bg = "NONE" })
		vim.api.nvim_set_hl(0, "DiagnosticUnderline" .. suffix, { sp = color, underline = true })
	end
end

return M
