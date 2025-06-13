return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300 -- 300ms로 설정
  end,
  opts = {
    preset = "modern",
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    win = {
      border = "rounded",
      padding = { 1, 2 },
      title = true,
      title_pos = "center",
      no_overlap = true,
      wo = {
        winblend = 10, -- 올바른 위치
      },
    },
    icons = {
      mappings = true,
      colors = true,
      breadcrumb = "»",
      separator = "➜",
      group = "+",
    },
    sort = { "local", "order", "group", "alphanum", "mod" },
    expand = 1,
    filter = function(mapping)
      return mapping.desc and mapping.desc ~= ""
    end,
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
