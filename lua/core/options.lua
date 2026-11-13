local o = vim.o
local opt = vim.opt

-- Disable mode text at bottom left (already in lualine)
opt.showmode = false

-- Disable aumenu on right click
opt.mousemodel = "extend"

-- Disable visual line wrapping to prevent lines from breaking prematurely
opt.wrap = false

-- Show cursor line highlighting for both screen line and line number
opt.cursorlineopt = "both"

-- Enable absolute line numbers
opt.number = true

-- Enable relative line numbers
opt.relativenumber = true

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

-- Hide fold column
opt.foldcolumn = "0"

-- Remove "~" under numbers
opt.fillchars = { eob = " " }

-- Disable automatic line breaks when typing beyond a certain width
opt.textwidth = 0

-- Disable linebreak option which controls where lines break visually
opt.linebreak = false

-- Enable horizontal scrolling instead of wrapping when lines exceed screen width
opt.sidescroll = 1

-- Keep a margin of 5 columns when scrolling horizontally
opt.sidescrolloff = 5

-- Show at least 8 rows before and after the cursor
opt.scrolloff = 8

-- Use system clipboard
opt.clipboard = "unnamedplus"

-- Set persistent undo for files
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- Ignore case in search patterns unless it contains a capital letter
opt.ignorecase = true
opt.smartcase = true

-- Force all horizontal splits to go below current window
opt.splitbelow = true

-- Force all vertical splits to go to the right of current window
opt.splitright = true

-- Decrease update time for faster completion and plugin responsiveness
opt.updatetime = 250

-- Decrease mapped sequence wait time (great for WhichKey)
opt.timeoutlen = 300

-- Treat dash-separated words as a single word text object
opt.iskeyword:append("-")

-- Enable 24-bit RGB color in the TUI
opt.termguicolors = true

-- Smart indenting when starting a new line
opt.smartindent = true

-- Briefly jump to the matching bracket when inserted
opt.showmatch = true

-- Tenths of a second to show the matching bracket
opt.matchtime = 2

-- Hide command line when not in use (makes the UI much cleaner)
opt.cmdheight = 1

-- Completion options (essential for modern completion engines like Blink.cmp)
opt.completeopt = "menuone,noinsert,noselect"

-- Maximum number of items to show in the popup menu
opt.pumheight = 10

-- Enables pseudo-transparency for the popup-menu
opt.pumblend = 10

-- Default border style for floating windows
opt.winborder = "rounded"

-- Disable swap files
opt.swapfile = false

-- Disable backup file creation during saves
opt.writebackup = false

-- Eliminate delay when pressing ESC
opt.ttimeoutlen = 0

-- Ignore compiled files and dependencies in native searches
opt.wildignore:append({ "*/node_modules/*", "*.o", "*.class", "*.jar" })

-- Folding settings specifically tailored for nvim-ufo
opt.foldlevel = 99 -- Set highest fold level...
opt.foldlevelstart = 99 -- ...so that all folds are open by default when a file is opened
opt.foldenable = true -- Enable folding
