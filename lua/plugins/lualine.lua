-- lua/plugins/lualine-optimized.lua
-- 성능 최적화된 lualine 설정

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "meuter/lualine-so-fancy.nvim",
  },
  enabled = true,
  lazy = false,
  event = { "BufReadPost", "BufNewFile", "VeryLazy" },
  config = function()
    -- 🔥 캐시 시스템으로 성능 최적화
    local function create_cached_function(fn, cache_time)
      local cache = { value = nil, time = 0 }
      return function()
        local now = vim.loop.now()
        if now - cache.time > cache_time then
          local success, result = pcall(fn)
          if success and result then
            cache.value = result
            cache.time = now
          end
        end
        return cache.value or ""
      end
    end

    local get_python_info = create_cached_function(function()
      if vim.bo.filetype ~= "python" then
        return ""
      end
      local venv = vim.env.VIRTUAL_ENV
      if venv then
        local venv_name = vim.fn.fnamemodify(venv, ":t")
        return "🐍(" .. venv_name .. ")"
      end
      return "🐍"
    end, 3000) -- 3초 캐시

    local get_memory_usage = create_cached_function(function()
      -- Linux/macOS에서만 작동
      if vim.fn.has("win32") == 1 then
        return ""
      end

      local handle = io.popen("ps -o rss= -p " .. vim.fn.getpid() .. " 2>/dev/null")
      if handle then
        local result = handle:read("*a")
        handle:close()
        if result and result ~= "" then
          local kb = tonumber(result:gsub("%s+", ""))
          if kb then
            local mb = math.floor(kb / 1024)
            return "💾" .. mb .. "MB"
          end
        end
      end
      return ""
    end, 8000) -- 8초 캐시

    local get_project_type = create_cached_function(function()
      local cwd = vim.fn.getcwd()
      local project_name = vim.fn.fnamemodify(cwd, ":t")
      if vim.fn.filereadable("requirements.txt") == 1 or vim.fn.filereadable("pyproject.toml") == 1 then
        return "🐍" .. project_name
      elseif vim.fn.filereadable("package.json") == 1 then
        return "📦" .. project_name
      elseif vim.fn.filereadable("Dockerfile") == 1 then
        return "🐳" .. project_name
      elseif vim.fn.filereadable("Cargo.toml") == 1 then
        return "🦀" .. project_name
      elseif vim.fn.glob("*.tf") ~= "" then
        return "🏗️" .. project_name
      else
        return "📁" .. project_name
      end
    end, 10000) -- 10초 캐시

    local get_git_info = create_cached_function(function()
      local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("%s+", "")
      if branch and branch ~= "" and vim.v.shell_error == 0 then
        if #branch > 20 then
          branch = branch:sub(1, 17) .. "..."
        end

        local icon = "🌿"
        if branch == "main" or branch == "master" then
          icon = "🏠"
        elseif branch:match("dev") then
          icon = "🚧"
        elseif branch:match("feat") then
          icon = "✨"
        end

        return icon .. branch
      end
      return ""
    end, 5000) -- 5초 캐시

    local function get_lsp_status()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then
        return "💤"
      end

      local names = {}
      for _, client in ipairs(clients) do
        local icon = "🚀"
        if client.name == "pyright" or client.name == "basedpyright" then
          icon = "🐍"
        elseif client.name == "rust_analyzer" then
          icon = "🦀"
        elseif client.name == "tsserver" then
          icon = "📦"
        end
        table.insert(names, icon)
      end

      return table.concat(names, "")
    end

    local function get_current_time()
      return "󰥔 " .. os.date("%H:%M")
    end

    require("lualine").setup({
      options = {
        theme = "edge",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        refresh = {
          statusline = 5000, -- 5초로 연장 (성능 향상)
          tabline = 10000,
          winbar = 10000,
        },
      },
      sections = {
        lualine_a = {
          {
            "fancy_mode",
            width = 3,
          },
        },
        lualine_b = {
          {
            get_git_info,
            color = { fg = "#98C379" },
          },
          {
            "fancy_diff",
            symbols = { added = " ", modified = " ", removed = " " },
          },
        },
        lualine_c = {
          {
            get_project_type,
            color = { fg = "#61AFEF" },
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
        },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = {
              error = "󰅚 ",
              warn = "󰀪 ",
              info = "󰋽 ",
              hint = "󰌶 ",
            },
            colored = true,
            update_in_insert = false,
          },
          {
            get_python_info,
            color = { fg = "#E5C07B" },
          },
        },
        lualine_y = {
          {
            get_lsp_status,
            color = { fg = "#98C379" },
          },
          {
            "fancy_filetype",
            ts_icon = "🌳",
          },
        },
        lualine_z = {
          {
            get_memory_usage,
            color = { fg = "#C678DD" },
          },
          {
            "fancy_location",
          },
          {
            get_current_time,
            color = { fg = "#ABB2BF" },
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = {
        "fzf",
        "neo-tree",
        "nvim-dap-ui",
        "trouble",
        "mason",
        "lazy",
        "man",
        "fugitive",
      },
    })

    vim.api.nvim_create_autocmd({
      "LspAttach",
      "LspDetach",
      "BufEnter",
      "WinEnter",
    }, {
      callback = function()
        vim.defer_fn(function()
          require("lualine").refresh()
        end, 300)
      end,
    })
  end,
}
