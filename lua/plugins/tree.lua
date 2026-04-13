local function open_file(api, open_fn)
	local wins = vim.api.nvim_list_wins()

	local real_windows = {}
	for _, win in ipairs(wins) do
		local buf = vim.api.nvim_win_get_buf(win)
		local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
		if ft ~= "NvimTree" and ft ~= "dashboard" then
			table.insert(real_windows, win)
		end
	end

	if #real_windows == 0 then
		local current_win = vim.api.nvim_get_current_win()
		local buf = vim.api.nvim_win_get_buf(current_win)
		local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })

		if ft == "dashboard" then
			vim.cmd("close")
		end

		api.node.open.edit()
	else
		open_fn()
	end
end

return {
	"nvim-tree/nvim-tree.lua",
	opts = {
		git = {
			enable = true,
		},
		renderer = {
			root_folder_label = false,
			indent_markers = {
				enable = true,
			},
			highlight_git = true,
			icons = {
				show = {
					git = true,
				},
			},
		},
		view = {
			side = "right",
		},
		update_focused_file = {
			enable = true,
		},
		sync_root_with_cwd = true,
		respect_buf_cwd = true,
		on_attach = function(bufnr)
			local api = require("nvim-tree.api")

			api.map.on_attach.default(bufnr)

			-- vertical split
			local function open_vsplit()
				vim.cmd("wincmd l")
				api.node.open.vertical()
			end

			-- horizontal split
			local function open_hsplit()
				vim.cmd("wincmd l")
				api.node.open.horizontal()
			end

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			vim.keymap.set("n", "v", function()
				open_file(api, open_vsplit)
			end, opts("Open: Vertical Split"))

			vim.keymap.set("n", "h", function()
				open_file(api, open_hsplit)
			end, opts("Open: Horizontal Split"))

			vim.keymap.set({ "n", "x" }, "d", api.fs.trash, opts("Trash"))
			vim.keymap.set({ "n", "x" }, "D", api.fs.remove, opts("Delete"))
		end,
	},
}
