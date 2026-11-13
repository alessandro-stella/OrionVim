return {
	"HiPhish/rainbow-delimiters.nvim",
	event = "BufReadPost",
	config = function()
		local rainbow_delimiters = require("rainbow-delimiters")
		vim.g.rainbow_delimiters = {
			strategy = {
				[""] = rainbow_delimiters.strategy["global"],
			},
			query = {
				[""] = "rainbow-delimiters",
			},
			highlight = {
				"RainbowDelimiterYellow",
				"RainbowDelimiterCyan",
				"RainbowDelimiterViolet",
			},
		}
	end,
}
