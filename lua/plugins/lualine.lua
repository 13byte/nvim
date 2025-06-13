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

    -- 💡 강화된 Python 정보 컴포넌트들
    local function get_python_info()
      local venv = vim.env.VIRTUAL_ENV
      local python_version = ""
      local venv_name = ""
      
      -- Python 버전 감지
      if vim.bo.filetype == "python" then
        local handle = io.popen("python3 --version 2>/dev/null")
        if handle then
          local result = handle:read("*a")
          handle:close()
          if result then
            python_version = result:match("Python ([%d%.]+)")
            if python_version then
              python_version = "🐍" .. python_version
            end
          end
        end
      end
      
      -- 가상환경 정보
      if venv then
        venv_name = "(" .. vim.fn.fnamemodify(venv, ":t") .. ")"
      end
      
      -- 조합된 정보 반환
      if python_version ~= "" and venv_name ~= "" then
        return python_version .. " " .. venv_name
      elseif python_version ~= "" then
        return python_version
      elseif venv_name ~= "" then
        return "🐍 " .. venv_name
      end
      
      return ""
    end

    -- 💡 시스템 메모리 사용량
    local function get_memory_usage()
      local handle = io.popen("ps -o pid,vsz,rss,comm -p " .. vim.fn.getpid() .. " | tail -1")
      if handle then
        local result = handle:read("*a")
        handle:close()
        if result then
          local rss = result:match("%s+%d+%s+%d+%s+(%d+)")
          if rss then
            local mb = math.floor(tonumber(rss) / 1024)
            return "💾" .. mb .. "MB"
          end
        end
      end
      return ""
    end

    -- 💡 Docker 상태 감지
    local function get_docker_status()
      -- Dockerfile이나 docker-compose.yml 존재 확인
      local has_dockerfile = vim.fn.filereadable("Dockerfile") == 1
      local has_compose = vim.fn.filereadable("docker-compose.yml") == 1 or vim.fn.filereadable("docker-compose.yaml") == 1
      
      if has_dockerfile or has_compose then
        -- Docker 데몬 실행 상태 확인
        local handle = io.popen("docker info >/dev/null 2>&1 && echo 'running' || echo 'stopped'")
        if handle then
          local result = handle:read("*a"):gsub("%s+", "")
          handle:close()
          if result == "running" then
            return "🐳✅"
          else
            return "🐳❌"
          end
        end
      end
      return ""
    end

    -- 💡 Kubernetes 컨텍스트
    local function get_k8s_context()
      local handle = io.popen("kubectl config current-context 2>/dev/null")
      if handle then
        local result = handle:read("*a"):gsub("%s+", "")
        handle:close()
        if result and result ~= "" then
          -- 컨텍스트명이 너무 길면 줄임
          if #result > 15 then
            result = result:sub(1, 12) .. "..."
          end
          return "⎈" .. result
        end
      end
      return ""
    end

    -- 💡 Git 브랜치 상태 강화
    local function get_enhanced_git_status()
      local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("%s+", "")
      if branch and branch ~= "" then
        -- 브랜치별 아이콘
        local icon = "🌿"
        if branch == "main" or branch == "master" then
          icon = "🏠"
        elseif branch:match("dev") or branch:match("develop") then
          icon = "🚧"
        elseif branch:match("feature") then
          icon = "✨"
        elseif branch:match("fix") or branch:match("hotfix") then
          icon = "🔧"
        end
        
        return icon .. branch
      end
      return ""
    end

    -- 💡 프로젝트 타입 감지
    local function get_project_type()
      local cwd = vim.fn.getcwd()
      local project_name = vim.fn.fnamemodify(cwd, ":t")
      
      -- 프로젝트 타입별 아이콘
      if vim.fn.filereadable("requirements.txt") == 1 or vim.fn.filereadable("pyproject.toml") == 1 then
        return "🐍" .. project_name
      elseif vim.fn.filereadable("package.json") == 1 then
        return "📦" .. project_name
      elseif vim.fn.filereadable("Dockerfile") == 1 then
        return "🐳" .. project_name
      elseif vim.fn.filereadable("terraform.tf") == 1 or vim.fn.glob("*.tf") ~= "" then
        return "🏗️" .. project_name
      elseif vim.fn.glob("*.yml") ~= "" or vim.fn.glob("*.yaml") ~= "" then
        return "⚙️" .. project_name
      else
        return "📁" .. project_name
      end
    end

    -- 💡 고급 LSP 정보
    local function get_advanced_lsp_status()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then
        return "💤"
      end
      
      local client_info = {}
      for _, client in ipairs(clients) do
        local icon = "🚀"
        -- LSP별 아이콘
        if client.name == "pyright" or client.name == "basedpyright" then
          icon = "🐍"
        elseif client.name == "terraformls" then
          icon = "🏗️"
        elseif client.name == "ansiblels" then
          icon = "⚙️"
        elseif client.name == "dockerls" then
          icon = "🐳"
        elseif client.name == "yamlls" then
          icon = "📄"
        end
        table.insert(client_info, icon .. client.name)
      end
      
      return table.concat(client_info, " ")
    end

    -- 💡 파일 정보 강화
    local function get_enhanced_file_info()
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
      
      -- 파일 크기에 따른 아이콘
      local icon = "📄"
      if i >= 3 then -- MB 이상
        icon = "📋"
      elseif i >= 4 then -- GB 이상
        icon = "📊"
      end
      
      return icon .. string.format("%.1f%s", size, suffixes[i])
    end

    -- 💡 현재 시간 (간단하게)
    local function get_current_time()
      return "󰥔 " .. os.date("%H:%M")
    end

    -- 💡 세션 정보 (별도 분리)
    local function get_session_info()
      local session_start = vim.g.session_start_time or os.time()
      local session_duration = os.time() - session_start
      local hours = math.floor(session_duration / 3600)
      local minutes = math.floor((session_duration % 3600) / 60)
      
      if hours > 0 then
        return "󰀠 " .. hours .. "h" .. minutes .. "m"
      else
        return "󰀠 " .. minutes .. "m"
      end
    end

    -- 세션 시작 시간 저장
    if not vim.g.session_start_time then
      vim.g.session_start_time = os.time()
    end

    require("lualine").setup({
      options = {
        theme = edge_theme,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        refresh = {
          statusline = 2000, -- 2초마다 업데이트 (시스템 정보를 위해)
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        -- 💡 강화된 왼쪽 섹션
        lualine_a = {
          {
            "fancy_mode",
            width = 3,
          },
        },
        lualine_b = {
          {
            get_enhanced_git_status,
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
          {
            get_enhanced_file_info,
            color = { fg = "#D19A66" },
          },
        },
        -- 💡 재배치된 오른쪽 섹션
        lualine_x = {
          {
            get_docker_status,
            color = { fg = "#56B6C2" },
          },
          {
            get_k8s_context,
            color = { fg = "#C678DD" },
          },
          {
            get_python_info,
            color = { fg = "#E5C07B" },
          },
          {
            "diagnostics",  -- 기본 진단 컴포넌트 사용 (더 안정적)
            sources = { "nvim_diagnostic" },
            symbols = { 
              error = "󰅚 ", 
              warn = "󰀪 ", 
              info = "󰋽 ", 
              hint = "󰌶 " 
            },
            diagnostics_color = {
              error = { fg = "#E06C75" },
              warn = { fg = "#E5C07B" },
              info = { fg = "#61AFEF" },
              hint = { fg = "#98C379" },
            },
            colored = true,
            update_in_insert = false,
          },
        },
        lualine_y = {
          {
            get_advanced_lsp_status,
            color = { fg = "#98C379" },
          },
          {
            "fancy_filetype",
            ts_icon = "🌳",
          },
          {
            get_current_time,  -- 시간을 y 섹션으로 이동
            color = { fg = "#61AFEF" },
          },
          {
            "encoding",
            fmt = string.upper,
            color = { fg = "#ABB2BF" },
          },
        },
        lualine_z = {
          {
            get_memory_usage,
            color = { fg = "#C678DD" },
          },
          {
            "fancy_location",
            color = { fg = "#E5C07B" },
          },
          {
            get_session_info,  -- 세션 정보를 마지막으로
            color = { fg = "#ABB2BF" },
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "filename",
            color = { fg = "#5C6370" },
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
        "man",      -- 추가
        "fugitive", -- 추가
      },
    })
    
    -- 💡 강화된 자동 새로고침 (성능 최적화)
    vim.api.nvim_create_autocmd({"User"}, {
      pattern = "LazyVimStarted",
      callback = function()
        vim.defer_fn(function()
          require("lualine").refresh()
        end, 500)
      end,
    })
    
    -- 💡 주요 변경사항에서만 새로고침 (성능 고려)
    vim.api.nvim_create_autocmd({
      "LspAttach", "LspDetach", "DiagnosticChanged", 
      "BufEnter", "WinEnter", "FileType"
    }, {
      callback = function()
        vim.defer_fn(function()
          require("lualine").refresh()
        end, 200)  -- 더 빠른 응답
      end,
    })

    -- 💡 Python 전용 키맵핑 (lualine 정보 표시)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        vim.keymap.set("n", "<leader>pi", function()
          -- 진단 정보 직접 가져오기
          local diagnostics = vim.diagnostic.get(0)
          local errors = 0
          local warnings = 0
          
          for _, diagnostic in ipairs(diagnostics) do
            if diagnostic.severity == vim.diagnostic.severity.ERROR then
              errors = errors + 1
            elseif diagnostic.severity == vim.diagnostic.severity.WARN then
              warnings = warnings + 1
            end
          end
          
          local lint_status = "✨ 문제없음"
          if errors > 0 then
            lint_status = "󰅚 " .. errors .. "개 오류"
          elseif warnings > 0 then
            lint_status = "󰀪 " .. warnings .. "개 경고"
          end

          local info = {
            "🐍 Python 환경 정보:",
            "• " .. (get_python_info() or "Python 정보 없음"),
            "• 코드 상태: " .. lint_status,
            "• 메모리 사용량: " .. get_memory_usage(),
            "• 프로젝트: " .. get_project_type(),
          }
          vim.notify(table.concat(info, "\n"), vim.log.levels.INFO)
        end, { desc = "Show Python environment info", buffer = true })
      end,
    })

    -- 💡 시스템 정보 키맵핑
    vim.keymap.set("n", "<leader>si", function()
      local info = {
        "🖥️ 시스템 정보:",
        "• 메모리: " .. get_memory_usage(),
        "• Docker: " .. (get_docker_status() ~= "" and get_docker_status() or "미설치"),
        "• Kubernetes: " .. (get_k8s_context() ~= "" and get_k8s_context() or "미설정"),
        "• 현재 시간: " .. get_current_time(),
        "• 세션 시간: " .. get_session_info(),
        "• LSP: " .. get_advanced_lsp_status(),
      }
      vim.notify(table.concat(info, "\n"), vim.log.levels.INFO)
    end, { desc = "Show system info" })
  end,
}