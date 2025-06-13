return {
  "nvim-zh/colorful-winsep.nvim",
  event = "WinNew",
  enabled = true,
  config = function()
    require("colorful-winsep").setup({
      -- 기본 색상 설정
      hi = {
        bg = "#16161E",
        fg = "#61AFEF", -- Edge 테마 파란색으로 고정
      },
      
      -- 비활성화할 파일타입 (충돌 방지)
      no_exec_files = {
        "packer",
        "TelescopePrompt", 
        "mason",
        "CompetiTest",
        "NvimTree",
        "neo-tree",
        "alpha",
        "dashboard",
        "lazy",
        "fzf",
        "avante",
        "noice",
        "notify",
        "trouble",
        "Trouble",
        "help",
      },
      
      -- 구분선 심볼 (고정 배열)
      symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
      
      -- 안전한 기본 설정
      only_line_seq = true,
      smooth = true,
      exponential_smoothing = true,
      
      -- 기본 앵커 설정
      anchor = {
        left = { height = 1, x = -1, y = -1 },
        right = { height = 1, x = -1, y = 0 },
        up = { width = 0, x = -1, y = 0 },
        bottom = { width = 0, x = 1, y = 0 },
      },
    })
    
    -- 💡 시간대별 동적 색상 변경 (setup 이후 적용)
    vim.defer_fn(function()
      local function get_time_based_color()
        local hour = tonumber(os.date("%H"))
        if hour >= 6 and hour < 12 then
          return "#98C379" -- 아침: 초록
        elseif hour >= 12 and hour < 18 then
          return "#61AFEF" -- 오후: 파랑
        else
          return "#C678DD" -- 저녁: 보라
        end
      end
      
      -- 현재 시간에 맞는 색상으로 즉시 업데이트
      vim.api.nvim_set_hl(0, "NvimSeparator", {
        fg = get_time_based_color(),
        bg = "#16161E"
      })
    end, 100) -- 100ms 후 실행
    
    -- Python 파일에서 간단한 색상 변경
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        -- Python 파일 타입별 간단한 색상 구분
        local bufname = vim.api.nvim_buf_get_name(0)
        local color = "#61AFEF" -- 기본 파랑
        
        if bufname:match("test_.*%.py$") then
          color = "#E06C75" -- 테스트 파일: 빨강
        elseif bufname:match("config.*%.py$") then
          color = "#E5C07B" -- 설정 파일: 노랑
        elseif bufname:match("main.*%.py$") then
          color = "#98C379" -- 메인 파일: 초록
        end
        
        vim.api.nvim_set_hl(0, "NvimSeparator", {
          fg = color,
          bg = "#16161E"
        })
        
        -- 간단한 정보 표시 키맵
        vim.keymap.set("n", "<leader>wc", function()
          local file_type = "📝 일반 Python"
          if bufname:match("test_") then file_type = "🧪 테스트"
          elseif bufname:match("config") then file_type = "⚙️ 설정"
          elseif bufname:match("main") then file_type = "🚀 메인" end
          
          vim.notify(file_type .. " 파일입니다", vim.log.levels.INFO)
        end, { desc = "Show file type", buffer = true })
      end,
    })
  end,
}