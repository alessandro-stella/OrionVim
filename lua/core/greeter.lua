local M = {}

local ART = {
	[[ .g8\"\"8q.             db                 `7MMF'   `7MF'db                   ]],
	[[.dP'    `YM.                                 `MA     ,V                       ]],
	[[dM'      `MM `7Mb,od8 `7MM  ,pW\"Wq.`7MMpMMMb VM:   ,V `7MM  `7MMpMMMb.pMMMb. ]],
	[[MM        MM   MM' \"'  MM 6W'   `Wb MM    MM  MM.  M'   MM    MM    MM    MM ]],
	[[MM.      ,MP   MM       MM 8M     M8 MM    MM  `MM A'    MM    MM    MM    MM ]],
	[[`Mb.    ,dP'   MM       MM YA.   ,A9 MM    MM   :MM;     MM    MM    MM    MM ]],
	[[ '\"bmmd\"'  .JMML.   .JMML.`Ybmd9'.JMML  JMML.  VF    .JMML..JMML  JMML  JMML]],
	[[                                                                              ]],
	[[                              Powered by  eovim                             ]],
}

local HL = "GreeterLogo"

local ns = vim.api.nvim_create_namespace("greeter")
local saved_tabline = nil

local function hide_tabline()
	if saved_tabline == nil then
		saved_tabline = vim.o.showtabline
	end
	vim.o.showtabline = 0
end

local function restore_tabline()
	if saved_tabline ~= nil then
		vim.o.showtabline = saved_tabline
		saved_tabline = nil
	end
end

local function is_greeter(buf)
	return vim.api.nvim_buf_is_valid(buf) and vim.b[buf].is_greeter == true
end

local function other_greeter_visible(except_buf)
	for _, w in ipairs(vim.api.nvim_list_wins()) do
		local b = vim.api.nvim_win_get_buf(w)
		if b ~= except_buf and is_greeter(b) then
			return true
		end
	end
	return false
end

local function is_blank(buf)
	return vim.api.nvim_buf_is_valid(buf)
		and vim.api.nvim_buf_get_name(buf) == ""
		and vim.bo[buf].buftype == ""
		and not vim.bo[buf].modified
		and vim.api.nvim_buf_line_count(buf) == 1
		and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""
end

local function render(buf)
	local win = vim.fn.bufwinid(buf)
	if win == -1 or not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	local h = vim.api.nvim_win_get_height(win)
	local w = vim.api.nvim_win_get_width(win)

	local block_w = 0
	for _, l in ipairs(ART) do
		block_w = math.max(block_w, vim.fn.strdisplaywidth(l))
	end

	local top = math.max(0, math.floor((h - #ART) / 2))
	local left = math.max(0, math.floor((w - block_w) / 2))
	local pad = string.rep(" ", left)

	local lines = {}
	for i = 1, top do
		lines[i] = ""
	end
	for _, l in ipairs(ART) do
		lines[#lines + 1] = pad .. l
	end

	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false

	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
	for i = 1, #ART do
		local row = top + i - 1
		vim.api.nvim_buf_set_extmark(buf, ns, row, left, { end_col = #lines[row + 1], hl_group = HL })
	end
end

function M.show(win)
	win = (win and vim.api.nvim_win_is_valid(win)) and win or vim.api.nvim_get_current_win()
	local prev = vim.api.nvim_win_get_buf(win)
	if is_greeter(prev) then
		return
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.bo[buf].filetype = "dashboard"
	vim.b[buf].is_greeter = true

	vim.api.nvim_win_set_buf(win, buf)

	if prev ~= buf and is_blank(prev) and #vim.fn.win_findbuf(prev) == 0 then
		pcall(vim.api.nvim_buf_delete, prev, {})
	end

	local names = { "number", "relativenumber", "signcolumn", "cursorline", "list", "statuscolumn" }
	local saved = {}
	for _, o in ipairs(names) do
		saved[o] = vim.wo[win][o]
	end
	vim.wo[win].number = false
	vim.wo[win].relativenumber = false
	vim.wo[win].signcolumn = "no"
	vim.wo[win].cursorline = false
	vim.wo[win].list = false
	vim.wo[win].statuscolumn = ""

	hide_tabline()
	render(buf)

	local group = vim.api.nvim_create_augroup("Greeter" .. buf, { clear = true })

	vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
		group = group,
		callback = function()
			render(buf)
		end,
	})

	vim.api.nvim_create_autocmd("BufWinLeave", {
		group = group,
		buffer = buf,
		once = true,
		callback = function()
			if vim.api.nvim_win_is_valid(win) then
				for o, v in pairs(saved) do
					vim.wo[win][o] = v
				end
			end
			if not other_greeter_visible(buf) then
				restore_tabline()
			end
			vim.api.nvim_del_augroup_by_id(group)
		end,
	})

	for _, key in ipairs({ "i", "a", "o", "I", "A", "O", "s", "S", "c", "C" }) do
		vim.keymap.set("n", key, function()
			vim.cmd("enew")
			vim.cmd("startinsert")
		end, { buffer = buf, nowait = true, silent = true })
	end
end

function M.delete_buf(buf, opts)
	opts = opts or {}
	buf = buf or vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_valid(buf) then
		return true
	end

	if vim.bo[buf].modified and not opts.force then
		local choice = vim.fn.confirm("Save changes?", "&Yes\n&No\n&Cancel", 3)
		if choice == 1 then
			vim.api.nvim_buf_call(buf, function()
				vim.cmd("write")
			end)
		elseif choice ~= 2 then
			return false
		end
	end

	local function candidate(b)
		return b ~= buf
			and vim.api.nvim_buf_is_valid(b)
			and vim.bo[b].buflisted
			and vim.bo[b].buftype == ""
			and vim.bo[b].filetype ~= "NvimTree"
	end

	for _, win in ipairs(vim.fn.win_findbuf(buf)) do
		vim.api.nvim_win_call(win, function()
			local alt = vim.fn.bufnr("#")
			if alt > 0 and candidate(alt) then
				vim.api.nvim_set_current_buf(alt)
				return
			end
			for _, b in ipairs(vim.api.nvim_list_bufs()) do
				if candidate(b) then
					vim.api.nvim_set_current_buf(b)
					return
				end
			end
			M.show(win)
		end)
	end

	pcall(vim.api.nvim_buf_delete, buf, { force = true })
	return true
end

function M.setup()
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			if vim.fn.argc() == 0 and is_blank(vim.api.nvim_get_current_buf()) then
				M.show()
			end
		end,
	})
end

return M
