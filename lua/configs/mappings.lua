local map = vim.keymap.set

-- Replace default paste behavior to avoit copying text overwritten by a paste
map("x", "p", [["_dP]])

-- CTRL+S to save
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", { silent = true })

-- CTRL+F search
map("n", "<C-f>", "/", { noremap = true })

-- TAB next buffer
map("n", "<Tab>", "<cmd>bnext<CR>", { silent = true })

-- SHIFT+TAB previous buffer
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { silent = true })

-- Close buffer
vim.keymap.set("n", "<leader>x", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local winnr = vim.api.nvim_get_current_win()

	if vim.bo[bufnr].filetype == "dashboard" or vim.bo[bufnr].filetype == "NvimTree" then
		return
	end

	require("bufdelete").bufdelete(bufnr, false)

	if vim.api.nvim_win_is_valid(winnr) then
		vim.api.nvim_win_close(winnr, true)
	end
end, { desc = "Close buffer and window" })

-- Open side bar
map("n", "<C-n>", "", { noremap = true })

-- Minor tweak for missclick
map("n", ";", ":", { desc = "CMD enter command mode" })

-- Code Actions
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

-- Easy exit from terminal mode
map("t", "<esc><esc>", "<c-\\><c-n>")

-- Mappings for telescope
local builtin = require("telescope.builtin")

map("n", "<leader>fo", builtin.oldfiles, { desc = "Telescope: Recent files" })
map("n", "<leader>ff", builtin.find_files, { desc = "Telescope: Find files" })
map("n", "<leader>fw", builtin.live_grep, { desc = "Telescope: Live grep" })

-- Move through windows
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Open sidebar
map("n", "<C-n>", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle File Explorer" })

-- Comment current line (Normal mode)
map("n", "<leader>/", "gcc", { remap = true, desc = "Comment current line" })

-- Comment selection (Visual mode)
map("v", "<leader>/", "gc", { remap = true, desc = "Comment selection" })

-- Go to definition
map("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })

-- Rename variable/function (uses LSP)
map("n", "<leader>ra", "<cmd>Lspsaga rename<CR>", { desc = "Rename variable" })
