return {
	"nvim-tree/nvim-tree.lua",
	keys = {
		{ "<C-n>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle File Explorer" },
	},
	opts = {
		git = { enable = true },
		renderer = {
			root_folder_label = false,
			symlink_destination = false,
			indent_markers = { enable = true },
			highlight_git = true,
			icons = {
				show = { git = true },
				glyphs = { folder = { arrow_closed = "󰅂", arrow_open = "󰅀" } },
			},
		},
		view = { side = "right" },
		update_focused_file = { enable = true },
		sync_root_with_cwd = true,
		respect_buf_cwd = true,
		on_attach = function(bufnr)
			local api = require("nvim-tree.api")
			api.map.on_attach.default(bufnr)

			local function open_vsplit()
				vim.cmd("wincmd l")
				api.node.open.vertical()
			end

			local function open_hsplit()
				vim.cmd("wincmd l")
				api.node.open.horizontal()
			end

			local function open_file(open_fn)
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

					if vim.api.nvim_get_option_value("filetype", { buf = buf }) == "dashboard" then
						vim.cmd("close")
					end

					api.node.open.edit()
				else
					open_fn()
				end
			end

			local function bind(key, action, desc)
				vim.keymap.set(
					"n",
					key,
					action,
					{ desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				)
			end

			bind("v", function()
				open_file(open_vsplit)
			end, "Open: Vertical Split")
			bind("h", function()
				open_file(open_hsplit)
			end, "Open: Horizontal Split")
			vim.keymap.set({ "n", "x" }, "d", api.fs.trash, { buffer = bufnr, nowait = true })
			vim.keymap.set({ "n", "x" }, "D", api.fs.remove, { buffer = bufnr, nowait = true })
		end,
	},

	config = function(_, opts)
		require("nvim-tree").setup(opts)

		local api = require("nvim-tree.api")
		local greeter = require("core.greeter")

		api.events.subscribe(api.events.Event.FileRemoved, function(data)
			for _, b in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_get_name(b) == data.fname then
					greeter.delete_buf(b, { force = true })
				end
			end
			vim.cmd.redrawtabline()
		end)

		api.events.subscribe(api.events.Event.FolderRemoved, function(data)
			local prefix = data.folder_name .. "/"
			for _, b in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_get_name(b):sub(1, #prefix) == prefix then
					greeter.delete_buf(b, { force = true })
				end
			end
			vim.cmd.redrawtabline()
		end)
	end,
}
