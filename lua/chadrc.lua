---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "onedark",
  transparency = true,

  hl_add = {
    St_permissions_icon = {
      fg = "#1f1f28",
      bg = "#FFAD5C",
    },
    St_permissions_sep = {
      fg = "#FFAD5C",
      bg = "#33333c",
    },
  },

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.ui = {
  border_style = "rounded",
  telescope = { style = "bordered" },
  statusline = {
    theme = "default",
    order = {
      "mode",
      "relativepath",
      "file",
      "git",
      "%=",
      "lsp_msg",
      "%=",
      "diagnostics",
      "lsp",
      "cwd",
      "cursor",
      "permissions",
    },
    modules = {
      relativepath = function()
        local path = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0))
        if path == "" then
          return ""
        end
        return "%#St_file# " .. vim.fn.expand "%:.:h" .. "/"
      end,

      permissions = function()
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname == "" then
          return ""
        end

        local stat = vim.loop.fs_stat(bufname)
        if not stat then
          return ""
        end

        local mode = stat.mode
        local icon = ""

        local function rwx(bits)
          local r = bit.band(bits, 0x4) ~= 0 and "r" or "-"
          local w = bit.band(bits, 0x2) ~= 0 and "w" or "-"
          local x = bit.band(bits, 0x1) ~= 0 and "x" or "-"
          return r .. w .. x
        end

        local owner = rwx(bit.rshift(bit.band(mode, 0x1C0), 6))
        local group = rwx(bit.rshift(bit.band(mode, 0x38), 3))
        local others = rwx(bit.band(mode, 0x7))

        local start_separator = "%#St_permissions_sep#"

        local icon_block = "%#St_permissions_icon#" .. icon .. " "

        local text_block = "%#St_file# " .. owner .. group .. others .. " "

        return start_separator .. icon_block .. text_block
      end,
    },
  },
}

M.nvdash = {
  load_on_startup = true,
  header = {
    "  .g8\"\"8q.              db                `7MMF'   `7MF'db                    ",
    ".dP'    `YM.                                `MA     ,V                        ",
    "dM'      `MM `7Mb,od8 `7MM  ,pW\"Wq.`7MMpMMMb.VM:   ,V `7MM  `7MMpMMMb.pMMMb.  ",
    "MM        MM   MM' \"'   MM 6W'   `Wb MM    MM MM.  M'   MM    MM    MM    MM  ",
    "MM.      ,MP   MM       MM 8M     M8 MM    MM `MM A'    MM    MM    MM    MM  ",
    "`Mb.    ,dP'   MM       MM YA.   ,A9 MM    MM  :MM;     MM    MM    MM    MM  ",
    "  `\"bmmd\"'   .JMML.   .JMML.`Ybmd9'.JMML  JMML. VF    .JMML..JMML  JMML  JMML.",
    "",
    " Powered by  eovim",
    "",
  },
}

return M
