return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local nvchad_defaults = {
      defaults = {
        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = " ",
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          width = 0.9,
          height = 0.80,
        },
        mappings = {
          n = { ["q"] = require("telescope.actions").close },
        },
      },
      extensions_list = { "themes", "terms" },
      extensions = {},
    }

    require("telescope").setup(nvchad_defaults)
    require("telescope").load_extension "fzf"

    local function get_hypr_border_color()
      local path = os.getenv "HOME" .. "/.config/hypr/dynamic-border.conf"
      local file = io.open(path, "r")
      if not file then
        return nil
      end

      local color
      for line in file:lines() do
        local match = line:match "rgba%((%x%x%x%x%x%x)"
        if match then
          color = "#" .. match
          break
        end
      end

      file:close()
      return color
    end

    local function apply_hypr_colors()
      local border_color = get_hypr_border_color() or "#FFFFFF"

      vim.api.nvim_set_hl(0, "FloatBorder", { fg = border_color, bg = "NONE" })

      vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = border_color, bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = border_color, bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = border_color, bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = border_color, bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = border_color, bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = border_color, bg = "NONE" })
    end

    apply_hypr_colors()
  end,
}
