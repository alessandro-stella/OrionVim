return {
	"nvimdev/dashboard-nvim",
	lazy = false,
	opts = function()
		local logo = [[
 .g8\"\"8q.             db                 `7MMF'   `7MF'db                   
.dP'    `YM.                                 `MA     ,V                       
dM'      `MM `7Mb,od8 `7MM  ,pW\"Wq.`7MMpMMMb.VM:   ,V `7MM  `7MMpMMMb.pMMMb. 
MM        MM   MM' \"'  MM 6W'   `Wb MM    MM  MM.  M'   MM    MM    MM    MM 
MM.      ,MP   MM       MM 8M     M8 MM    MM  `MM A'    MM    MM    MM    MM 
`Mb.    ,dP'   MM       MM YA.   ,A9 MM    MM   :MM;     MM    MM    MM    MM 
 '\"bmmd\"'  .JMML.   .JMML.`Ybmd9'.JMML  JMML.  VF    .JMML..JMML  JMML  JMML
                                                                              
                              Powered by  eovim                             
]]

		logo = string.rep("\n", 7) .. logo .. "\n"

		local opts = {
			theme = "doom",
			hide = {
				statusline = false,
			},
			config = {
				header = vim.split(logo, "\n"),
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
