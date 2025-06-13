return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "meuter/lualine-so-fancy.nvim",
  },
  enabled = true,
  lazy = false,
  event = { "BufReadPost", "BufNewFile", "VeryLazy" },
  config = function()
    -- Edge 테마 사용 (내장 테마 활용)
    local edge_theme = 'edge'

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
        theme = edge_theme,  -- Edge 테마 사용
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
          },
        },
        lualine_b = {
          {
            "fancy_branch",
            icon = "🌿",
          },
          {
            "fancy_diff",
            symbols = { added = " ", modified = " ", removed = " " },
          },
        },
        lualine_c = {
          {
            "fancy_cwd",
            substitute_home = true,
            icon = "📂",
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
          },
          {
            get_file_size,
            icon = "📏",
          },
        },
        -- 오른쪽 섹션
        lualine_x = {
          {
            get_python_venv,
          },
          {
            "fancy_diagnostics",
            sources = { "nvim_lsp" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
          },
          {
            get_lsp_status,
          },
        },
        lualine_y = {
          {
            "fancy_filetype",
            ts_icon = "🌳",
          },
          {
            "encoding",
            fmt = string.upper,
          },
          {
            "fileformat",
            symbols = {
              unix = "󰻀",
              dos = "󰍲",
              mac = "󰀵",
            },
          },
        },
        lualine_z = {
          {
            "fancy_location",
          },
          {
            get_current_time,
            icon = "🕐",
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "filename",
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
