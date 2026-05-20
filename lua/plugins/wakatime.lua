return {
	"wakatime/vim-wakatime",
	lazy = false,

	init = function()
		vim.g.wakatime_project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	end,
}
