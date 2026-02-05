require "nvchad.autocmds"

-- Show dashboard on last buffer close
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    local bufs = vim.t.bufs
    if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
      vim.schedule(function()
        vim.cmd "Nvdash"
      end)
    end
  end,
})

-- Configure jdtls for java projects
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function(_)
    require("configs.jdtls_setup"):setup()
  end,
})

-- Change tab from spaces to actual tab for text files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "text", "conf", "" },
  callback = function()
    vim.opt.expandtab = false
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 0
  end,
})

-- Change dashboard logo color on start
local function get_hypr_border_color()
  local path = os.getenv "HOME" .. "/.config/hypr/dynamic-border.conf"
  local file = io.open(path, "r")
  if not file then
    return "#8796B5"
  end

  local colors = {}
  for line in file:lines() do
    for color in line:gmatch "rgba%((%x%x%x%x%x%x)%x%x%)" do
      table.insert(colors, "#" .. color)
    end
  end
  file:close()

  return colors[1] or "#8796B5"
end

vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    vim.api.nvim_set_hl(0, "NvDashAscii", { fg = get_hypr_border_color() })
  end,
})
