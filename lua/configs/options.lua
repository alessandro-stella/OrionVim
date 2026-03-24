local o = vim.o
local opt = vim.opt

-- Disable mode text at bottom left (already in lualine)
opt.showmode = false

-- Disable aumenu on right click
opt.mousemodel = "extend"

-- Disable visual line wrapping to prevent lines from breaking prematurely
o.wrap = false

-- Show cursor line highlighting for both screen line and line number
o.cursorlineopt = "both"

-- Enable absolute line numbers
o.number = true

-- Enable relative line numbers
o.relativenumber = true

-- Force single status line
opt.laststatus = 3

-- Force tab bar for buffer line
opt.showtabline = 2

-- Increase number column side
opt.numberwidth = 3

-- Add focus for current line
opt.cursorline = true

-- Transform tabs into spaces
opt.expandtab = true

-- Number of spaces for indentation
opt.shiftwidth = 2

-- Spaces occupied by a tab
opt.tabstop = 2

-- Spaces inserted when pressing tab
opt.softtabstop = 2

-- Add signs near side bar
opt.signcolumn = "yes"

-- Remove "~" under numbers
opt.fillchars = { eob = " " }

-- Disable automatic line breaks when typing beyond a certain width
opt.textwidth = 0

-- Disable linebreak option which controls where lines break visually (only relevant if wrap is enabled)
opt.linebreak = false

-- Enable horizontal scrolling instead of wrapping when lines exceed screen width
opt.sidescroll = 1

-- Keep a margin of 5 columns when scrolling horizontally
opt.sidescrolloff = 5

-- Show at least 5 rows before and after the cursor
opt.scrolloff = 5
