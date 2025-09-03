-- plugins/lualine.lua
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { 
    "nvim-tree/nvim-web-devicons",
    "sainnhe/edge"
  },
  event = "VeryLazy",
  config = function()
    -- Edge 팔레트 로드
    local palette = require("config.edge-palette").colors
    local lualine = require("lualine")

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
      check_git_workspace = function()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
      end,
    }

    -- Config
    local config = {
      options = {
        icons_enabled = true,
        theme = 'edge', -- Edge 테마 사용
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "lazy" },
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = { 'fugitive', 'neo-tree', 'trouble', 'lazy' }
    }

    -- Helper functions
    local function ins_left(component)
      table.insert(config.sections.lualine_c, component)
    end

    local function ins_right(component)
      table.insert(config.sections.lualine_x, component)
    end

    -- Left side
    ins_left({
      function() return '▊' end,
      color = { fg = palette.blue },
      padding = { left = 0, right = 1 },
    })

    ins_left({
      -- mode component
      function()
        return ''
      end,
      color = function()
        -- Edge 테마 색상으로 모드 표시
        local mode_color = {
          n = palette.blue,      -- Normal
          i = palette.green,     -- Insert
          v = palette.purple,    -- Visual
          [''] = palette.purple,
          V = palette.purple,
          c = palette.orange,    -- Command
          no = palette.red,
          s = palette.cyan,      -- Select
          S = palette.cyan,
          [''] = palette.cyan,
          ic = palette.yellow,
          R = palette.red,       -- Replace
          Rv = palette.red,
          cv = palette.red,
          ce = palette.red,
          r = palette.cyan,
          rm = palette.cyan,
          ['r?'] = palette.cyan,
          ['!'] = palette.red,
          t = palette.orange,    -- Terminal
        }
        return { fg = mode_color[vim.fn.mode()], gui = 'bold' }
      end,
      padding = { right = 1 },
    })

    ins_left({
      'filesize',
      cond = conditions.buffer_not_empty,
      color = { fg = palette.grey },
    })

    ins_left({
      'filename',
      cond = conditions.buffer_not_empty,
      color = { fg = palette.fg, gui = 'bold' },
      symbols = {
        modified = ' ●',
        readonly = ' ',
        unnamed = '[No Name]',
        newfile = '[New]',
      },
    })

    ins_left({ 
      'location',
      color = { fg = palette.grey }
    })

    ins_left({ 
      'progress', 
      color = { fg = palette.fg, gui = 'bold' }
    })

    ins_left({
      'diagnostics',
      sources = { 'nvim_diagnostic' },
      symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
      diagnostics_color = {
        error = { fg = palette.red },
        warn = { fg = palette.yellow },
        info = { fg = palette.cyan },
        hint = { fg = palette.purple },
      },
    })

    -- Middle separator
    ins_left({
      function() return '%=' end,
    })

    ins_left({
      -- Lsp server name
      function()
        local msg = 'No LSP'
        local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
        local clients = vim.lsp.get_clients()
        if next(clients) == nil then
          return msg
        end
        local client_names = {}
        for _, client in ipairs(clients) do
          local filetypes = client.config.filetypes
          if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            table.insert(client_names, client.name)
          end
        end
        if #client_names > 0 then
          return ' ' .. table.concat(client_names, ', ')
        end
        return msg
      end,
      icon = ' ',
      color = { fg = palette.purple, gui = 'bold' },
    })

    -- Right side
    ins_right({
      -- Python virtual environment
      function()
        local venv = vim.env.VIRTUAL_ENV
        if venv then
          local venv_name = vim.fn.fnamemodify(venv, ':t')
          return '󰌠 ' .. venv_name
        end
        return ''
      end,
      cond = function()
        return vim.bo.filetype == 'python'
      end,
      color = { fg = palette.green, gui = 'bold' },
    })

    ins_right({
      'o:encoding',
      fmt = string.upper,
      cond = conditions.hide_in_width,
      color = { fg = palette.grey },
    })

    ins_right({
      'fileformat',
      fmt = string.upper,
      icons_enabled = true,
      color = { fg = palette.grey },
    })

    ins_right({
      'branch',
      icon = '',
      color = { fg = palette.purple, gui = 'bold' },
    })

    ins_right({
      'diff',
      symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
      diff_color = {
        added = { fg = palette.green },
        modified = { fg = palette.yellow },
        removed = { fg = palette.red },
      },
      cond = conditions.hide_in_width,
    })

    ins_right({
      function() return '▊' end,
      color = { fg = palette.blue },
      padding = { left = 1 },
    })

    lualine.setup(config)
  end,
}