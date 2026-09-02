return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",

	config = function()
		require("nvim-treesitter").install({
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
		})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)

				if not lang then
					return
				end

				pcall(vim.treesitter.start, args.buf, lang)

				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
