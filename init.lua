-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Additional paths
local data_path = vim.fn.stdpath("data")
vim.opt.rtp:prepend(data_path .. "/site")

-- Core settings
require("core.options")
require("core.autocmds")
require("core.mappings")

-- Bootstrappng lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Initialize lazy.nvim
require("lazy").setup({
	{ import = "plugins.ui" },
	{ import = "plugins.lsp" },
	{ import = "plugins.editor" },
}, {
	ui = {
		border = "rounded",
	},
})

-- Additional graphical settings
require("core.tabline")
require("core.highlights").setup()
require("core.dynamic-borders").setup()
require("core.greeter").setup()

-- Prolog setup
vim.filetype.add({
	pattern = {
		[".*/prolog/.*%.pl"] = "prolog",
	},
})
