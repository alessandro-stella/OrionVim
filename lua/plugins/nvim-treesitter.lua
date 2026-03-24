return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		ensure_installed = {
			"c",
			"cpp",
			"python",
			"lua",
			"html",
			"css",
			"json",
			"yaml",
			"javascript",
			"typescript",
			"java",
			"prisma",
			"bash",
			"solidity",
			"svelte",
			"vim",
			"vimdoc",
			"query",
		},
		auto_install = true,
		highlight = {
			enable = true,
			-- Disable for huge file, >100 100 KB
			disable = function(_, buf)
				local max_filesize = 100 * 1024
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end,
		},
		indent = { enable = true },
	},
}
