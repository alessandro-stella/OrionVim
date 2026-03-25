local data_path = vim.fn.stdpath("data")
vim.opt.rtp:prepend(data_path .. "/site")

require("core.lazy")
require("configs.options")
require("configs.autocmds")
require("configs.mappings")
require("core.lsp")
require("configs.tabline")

require("configs.highlights").setup()
require("configs.dynamic_borders").setup()
