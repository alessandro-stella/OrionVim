local function center_pad(logo_lines, center_items, footer_lines)
	local total_height = vim.o.lines

	local content_height = #logo_lines + #center_items + footer_lines + 4 -- extra margin

	local padding = math.floor((total_height - content_height) / 2)

	if padding < 0 then
		padding = 0
	else
		padding = padding - 1 -- improves visual balance
	end

	return string.rep("\n", padding)
end

return {
	"nvimdev/dashboard-nvim",
	lazy = false,
	opts = function()
		local logo = [[
 .g8\"\"8q.             db                 `7MMF'   `7MF'db                   
.dP'    `YM.                                 `MA     ,V                       
dM'      `MM `7Mb,od8 `7MM  ,pW\"Wq.`7MMpMMMb VM:   ,V `7MM  `7MMpMMMb.pMMMb. 
MM        MM   MM' \"'  MM 6W'   `Wb MM    MM  MM.  M'   MM    MM    MM    MM 
MM.      ,MP   MM       MM 8M     M8 MM    MM  `MM A'    MM    MM    MM    MM 
`Mb.    ,dP'   MM       MM YA.   ,A9 MM    MM   :MM;     MM    MM    MM    MM 
 '\"bmmd\"'  .JMML.   .JMML.`Ybmd9'.JMML  JMML.  VF    .JMML..JMML  JMML  JMML
                                                                              
                              Powered by  eovim                             
]]

		local opts = {
			theme = "doom",
			hide = {
				statusline = false,
			},
			config = {
        		-- stylua: ignore
        		center = {
        			{ action = 'Telescope find_files', desc = " Find File",     icon = " ", key = "f" },
        			{ action = "ene | startinsert",    desc = " New File",      icon = " ", key = "n" },
        			{ action = 'Telescope oldfiles',   desc = " Recent Files",  icon = " ", key = "r" },
        			{ action = 'Telescope live_grep',  desc = " Find Text",     icon = " ", key = "g" },
        			{ action = "Lazy",                 desc = " Lazy",          icon = "󰒲 ", key = "l" },
        			{ action = "qa",                   desc = " Quit",          icon = " ", key = "q" },
        		},
				footer = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					return { "Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
				end,
			},
		}

		local logo_lines = vim.split(logo, "\n")

		local pad = center_pad(
			logo_lines,
			opts.config.center,
			1 -- footer
		)

		logo = pad .. logo .. "\n"
		opts.config.header = vim.split(logo, "\n")

		for _, button in ipairs(opts.config.center) do
			button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
			button.key_format = "  %s"
		end

		-- open dashboard after closing lazy
		if vim.o.filetype == "lazy" then
			vim.api.nvim_create_autocmd("WinClosed", {
				pattern = tostring(vim.api.nvim_get_current_win()),
				once = true,
				callback = function()
					vim.schedule(function()
						vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
					end)
				end,
			})
		end

		return opts
	end,
}
