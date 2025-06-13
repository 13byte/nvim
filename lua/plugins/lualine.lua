return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "meuter/lualine-so-fancy.nvim",
  },
  enabled = true,
  lazy = false,
  event = { "BufReadPost", "BufNewFile", "VeryLazy" },
  config = function()
    -- Catppuccin 색상 가져오기
    local colors = require("catppuccin.palettes").get_palette("mocha")
    
    -- 커스텀 테마 정의
    local custom_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.mantle, gui = "bold" },
        b = { bg = colors.surface1, fg = colors.blue },
        c = { bg = colors.mantle, fg = colors.text },
      },
      insert = {
        a = { bg = colors.green, fg = colors.mantle, gui = "bold" },
        b = { bg = colors.surface1, fg = colors.green },
      },
      visual = {
        a = { bg = colors.mauve, fg = colors.mantle, gui = "bold" },
        b = { bg = colors.surface1, fg = colors.mauve },
      },
      command = {
        a = { bg = colors.peach, fg = colors.mantle, gui = "bold" },
        b = { bg = colors.surface1, fg = colors.peach },
      },
      replace = {
        a = { bg = colors.red, fg = colors.mantle, gui = "bold" },
        b = { bg = colors.surface1, fg = colors.red },
      },
      inactive = {
        a = { bg = colors.surface0, fg = colors.overlay1 },
        b = { bg = colors.surface0, fg = colors.overlay1 },
        c = { bg = colors.mantle, fg = colors.overlay0 },
      },
    }

    -- 커스텀 컴포넌트들
    local function get_python_venv()
      local venv = vim.env.VIRTUAL_ENV
      if venv then
        local venv_name = vim.fn.fnamemodify(venv, ":t")
        return "🐍 " .. venv_name
      end
      return ""
    end

    local function get_lsp_status()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then
        return "😴 No LSP"
      end
      
      local client_names = {}
      for _, client in ipairs(clients) do
        table.insert(client_names, client.name)
      end
      return "🚀 " .. table.concat(client_names, ", ")
    end

    local function get_file_size()
      local file = vim.fn.expand("%:p")
      if file == "" then return "" end
      
      local size = vim.fn.getfsize(file)
      if size <= 0 then return "" end
      
      local suffixes = {"B", "KB", "MB", "GB"}
      local i = 1
      while size > 1024 and i < #suffixes do
        size = size / 1024
        i = i + 1
      end
      return string.format("%.1f%s", size, suffixes[i])
    end

    local function get_current_time()
      return os.date("%H:%M")
    end

    local function get_project_root()
      local root = vim.fn.getcwd()
      return "📁 " .. vim.fn.fnamemodify(root, ":t")
    end

    require("lualine").setup({
      options = {
        theme = custom_theme,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        refresh = {
          statusline = 500,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        -- 왼쪽 섹션
        lualine_a = {
          {
            "fancy_mode",
            width = 3,
            color = function()
              local mode_colors = {
                n = colors.blue,
                i = colors.green,
                v = colors.mauve,
                V = colors.mauve,
                c = colors.peach,
                R = colors.red,
                t = colors.teal,
              }
              return { fg = colors.mantle, bg = mode_colors[vim.fn.mode():sub(1,1)] or colors.blue, gui = "bold" }
            end,
          },
        },
        lualine_b = {
          {
            "fancy_branch",
            icon = "🌿",
            color = { fg = colors.green, bg = colors.surface1 },
          },
          {
            "fancy_diff",
            symbols = { added = " ", modified = " ", removed = " " },
            diff_color = {
              added = { fg = colors.green },
              modified = { fg = colors.yellow },
              removed = { fg = colors.red },
            },
          },
        },
        lualine_c = {
          {
            "fancy_cwd",
            substitute_home = true,
            icon = "📂",
            color = { fg = colors.sapphire, bg = colors.surface0 },
          },
          {
            "filename",
            path = 1,
            symbols = {
              modified = " 󰷥",
              readonly = " 󰌾",
              unnamed = " 󰎞",
              newfile = " 󰄛",
            },
            color = { fg = colors.text },
          },
          {
            get_file_size,
            icon = "📏",
            color = { fg = colors.overlay2 },
          },
        },
        -- 오른쪽 섹션
        lualine_x = {
          {
            get_python_venv,
            color = { fg = colors.yellow, bg = colors.surface1 },
          },
          {
            "fancy_diagnostics",
            sources = { "nvim_lsp" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
            diagnostics_color = {
              error = { fg = colors.red },
              warn = { fg = colors.yellow },
              info = { fg = colors.sky },
              hint = { fg = colors.teal },
            },
          },
          {
            get_lsp_status,
            color = { fg = colors.lavender },
          },
        },
        lualine_y = {
          {
            "fancy_filetype",
            ts_icon = "🌳",
            color = { fg = colors.blue, bg = colors.surface1 },
          },
          {
            "encoding",
            fmt = string.upper,
            color = { fg = colors.green },
          },
          {
            "fileformat",
            symbols = {
              unix = "󰻀",
              dos = "󰍲",
              mac = "󰀵",
            },
            color = { fg = colors.teal },
          },
        },
        lualine_z = {
          {
            "fancy_location",
            color = { fg = colors.mantle, bg = colors.blue, gui = "bold" },
          },
          {
            get_current_time,
            icon = "🕐",
            color = { fg = colors.mantle, bg = colors.mauve, gui = "bold" },
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "filename",
            color = { fg = colors.overlay1 },
          },
        },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {
        "fzf",
        "neo-tree",
        "nvim-dap-ui",
        "trouble",
        "mason",
        "lazy",
      },
    })
    
    -- 가벼운 자동 새로고침을 위한 autocmd
    vim.api.nvim_create_autocmd({"User"}, {
      pattern = "LazyVimStarted",
      callback = function()
        vim.defer_fn(function()
          require("lualine").refresh()
        end, 200)
      end,
    })
    
    -- LSP 연결 시에만 새로고침
    vim.api.nvim_create_autocmd({"LspAttach", "LspDetach"}, {
      callback = function()
        vim.defer_fn(function()
          require("lualine").refresh()
        end, 100)
      end,
    })
  end,
}
