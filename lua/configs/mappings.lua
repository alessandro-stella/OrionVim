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

-- Remap copy and paste to use global clipboard
map("n", "y", '"+y')
map("n", "yy", '"+yy')
map("n", "Y", '"+Y')
map("x", "y", '"+y')
map("x", "Y", '"+Y')

-- Remove search highlighting
map("n", "<Esc>", ":nohlsearch<CR><Esc>", { noremap = true, silent = true })

-- ================================================
-- =============  Close buffer logic  =============
-- ================================================

-- Helper: count listed normal buffers (excluding nvim-tree)
local function count_buffers()
	local count = 0
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buflisted and vim.bo[buf].filetype ~= "NvimTree" then
			count = count + 1
		end
	end

	return count
end

-- Close buffer and window
vim.keymap.set("n", "<leader>x", function()
	local curr_buf = vim.api.nvim_get_current_buf()
	if vim.bo[curr_buf].filetype == "NvimTree" then
		return
	end

	local open_buffers = count_buffers()

	vim.cmd("Bdelete")

	if open_buffers == 1 then
		vim.cmd("only")
		vim.cmd("Dashboard")
	else
		local wins = vim.api.nvim_list_wins()
		local count = 0

		for _, win in ipairs(wins) do
			local buf = vim.api.nvim_win_get_buf(win)
			local ft = vim.bo[buf].filetype
			local bt = vim.bo[buf].buftype

			if bt == "" and ft ~= "NvimTree" then
				count = count + 1

				if count ~= 1 then
					vim.cmd("q")
					return
				end
			end
		end
	end
end, { noremap = true, silent = true, desc = "Close buffer" })

-- Vertical split if at least 2 normal buffers
vim.keymap.set("n", "<leader>v", function()
	if vim.bo.filetype == "NvimTree" then
		return
	end

	if count_buffers() < 2 then
		print("Not enough buffers to open a vertical split")
		return
	end

	vim.cmd("vsplit")
end, { noremap = true, silent = true, desc = "Split window vertically" })

-- Horizontal split if at least 2 normal buffers
vim.keymap.set("n", "<leader>h", function()
	if vim.bo.filetype == "NvimTree" then
		return
	end

	if count_buffers() < 2 then
		print("Not enough buffers to open a horizontal split")
		return
	end

	vim.cmd("split")
end, { noremap = true, silent = true, desc = "Split window horizontally" })
