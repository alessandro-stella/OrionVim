local map = vim.keymap.set

-- Safely close buffer
vim.keymap.set("n", "<leader>x", function()
	local greeter = require("core.greeter")
	local buf = vim.api.nvim_get_current_buf()
	local ft = vim.bo[buf].filetype
	if ft == "NvimTree" or ft == "dashboard" then
		return
	end

	if not greeter.delete_buf(buf) then
		return -- annullato
	end

	if #vim.fn.getbufinfo({ buflisted = 1 }) == 0 then
		pcall(vim.cmd, "only")
		return
	end

	local count = 0
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local b = vim.api.nvim_win_get_buf(win)
		if vim.bo[b].buftype == "" and vim.bo[b].filetype ~= "NvimTree" then
			count = count + 1
			if count ~= 1 then
				vim.cmd("q")
				return
			end
		end
	end
end, { noremap = true, silent = true, desc = "Close buffer" })

-- Replace default paste behavior to avoit copying text overwritten by a paste
map("x", "p", [["_dP]])

-- CTRL+S to save
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", { silent = true })

-- CTRL+F search
map("n", "<C-f>", "/", { noremap = true })

-- CTRL+A select all
map("n", "<C-a>", "ggVG", { noremap = true })

-- TAB next buffer
map("n", "<Tab>", "<cmd>bnext<CR>", { silent = true })

-- SHIFT+TAB previous buffer
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { silent = true })

-- Minor tweak for missclick
map("n", ";", ":", { desc = "CMD enter command mode" })

-- Code Actions
map({ "n", "v" }, "<leader>ca", function()
	vim.lsp.buf.code_action({
		filter = function(action)
			return not action.disabled
		end,
	})
end, { desc = "Code Action" })

-- Easy exit from terminal mode
map("t", "<esc><esc>", "<c-\\><c-n>")

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

-- Go to references
map("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })

-- Go to implementation
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })

-- Navigate diagnostics (errors/warnings)
map("n", "[d", function()
	vim.diagnostic.jump({ count = -1 })
end, { desc = "Go to previous diagnostic message" })
map("n", "]d", function()
	vim.diagnostic.jump({ count = 1 })
end, { desc = "Go to next diagnostic message" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic error messages" })

-- Rename variable/function (uses LSP)
map("n", "<leader>ra", "<cmd>Lspsaga rename<CR>", { desc = "Rename variable" })

-- Remove search highlighting
map("n", "<Esc>", ":nohlsearch<CR><Esc>", { noremap = true, silent = true })

-- Remap CTRL + SHIFT + Z to "redo" for too many "undo"
vim.keymap.set("n", "<C-S-z>", "<C-r>", { desc = "Redo" })

-- Keep visual mode selection after indenting
map("v", "<", "<gv", { desc = "Indent left and re-select" })
map("v", ">", ">gv", { desc = "Indent right and re-select" })

-- Move selected lines up and down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- Keep cursor in place when joining lines (J in normal mode)
map("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

-- Center the cursor on screen while jumping through search results
map("n", "n", "nzzzv", { desc = "Next search result" })
map("n", "N", "Nzzzv", { desc = "Previous search result" })

-- Center the cursor when paging up and down
map("n", "<C-d>", "<C-d>zz", { desc = "Page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Page up" })

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

local function search_and_replace_normal()
	vim.ui.input({ prompt = "Replace (regex): " }, function(from)
		if not from or from == "" then
			return
		end

		vim.fn.setreg("/", from)
		vim.opt.hlsearch = true
		vim.cmd("redraw")

		vim.ui.input({ prompt = "With: " }, function(to)
			if not to then
				return
			end

			vim.ui.input({ prompt = "Flag (default g): ", default = "g" }, function(flags)
				if not flags then
					flags = "g"
				end

				local cmd = string.format("%%s/%s/%s/%s", from:gsub("/", "\\/"), to:gsub("/", "\\/"), flags)

				local status, err = pcall(vim.cmd, cmd)
				if not status then
					vim.notify("Error during command: " .. err, vim.log.levels.ERROR)
				end

				vim.cmd("nohlsearch")
			end)
		end)
	end)
end

vim.keymap.set("n", "<leader>fr", search_and_replace_normal, { desc = "Search and replace" })
