return {
  "HiPhish/rainbow-delimiters.nvim",
  event = "VeryLazy",
  config = function()
    local rainbow_delimiters = require("rainbow-delimiters")
    
    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rainbow_delimiters.strategy["global"], -- 기본 전략
        python = rainbow_delimiters.strategy["local"], -- Python은 로컬 전략 사용 (성능 최적화)
      },
      
      -- 💡 Python 특화 쿼리 최적화
      query = {
        [""] = "rainbow-delimiters", -- 기본 쿼리
        python = "rainbow-delimiters", -- Python 전용 쿼리 (향후 커스터마이징 가능)
      },
      
      priority = {
        [""] = 110, -- 기본 우선순위
        python = 120, -- Python 우선순위 증가 (다른 하이라이팅보다 우선)
      },
      
      -- 💡 더 많은 색상으로 깊은 중첩 지원 (10단계)
      highlight = {
        "RainbowDelimiterRed",      -- 1단계
        "RainbowDelimiterYellow",   -- 2단계
        "RainbowDelimiterBlue",     -- 3단계
        "RainbowDelimiterOrange",   -- 4단계
        "RainbowDelimiterGreen",    -- 5단계
        "RainbowDelimiterViolet",   -- 6단계
        "RainbowDelimiterCyan",     -- 7단계
        "RainbowDelimiterPink",     -- 8단계 (추가)
        "RainbowDelimiterGray",     -- 9단계 (추가)
        "RainbowDelimiterLightBlue", -- 10단계 (추가)
      },
      
      blacklist = {}, -- 비활성화할 언어들
      
      -- 💡 특정 Python 구문에서만 활성화 (다른 언어 제외)
      whitelist = { "python" }, -- Python만 활성화
    }
    
    -- Python에 특화된 추가 설정 및 10단계 색상 정의
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        -- Python에서 특별히 강조할 구문들 + 추가 3개 색상
        vim.cmd [[
          " 기본 7색상 (Edge 테마 호환)
          hi def RainbowDelimiterRed    guifg=#E06C75 ctermfg=204
          hi def RainbowDelimiterYellow guifg=#E5C07B ctermfg=180  
          hi def RainbowDelimiterBlue   guifg=#61AFEF ctermfg=39
          hi def RainbowDelimiterOrange guifg=#D19A66 ctermfg=173
          hi def RainbowDelimiterGreen  guifg=#98C379 ctermfg=114
          hi def RainbowDelimiterViolet guifg=#C678DD ctermfg=170
          hi def RainbowDelimiterCyan   guifg=#56B6C2 ctermfg=38
          
          " 추가 3색상 (깊은 중첩용)
          hi def RainbowDelimiterPink       guifg=#FF69B4 ctermfg=205
          hi def RainbowDelimiterGray       guifg=#ABB2BF ctermfg=145
          hi def RainbowDelimiterLightBlue  guifg=#87CEEB ctermfg=117
        ]]
        
        -- Python 특화 중첩 구조 안내 메시지
        if vim.fn.line('$') > 100 then -- 100줄 이상 파일에서만
          vim.notify("🌈 Rainbow Delimiters: 10단계 중첩 색상 활성화", vim.log.levels.INFO)
        end
      end,
    })
    
    -- Python 개발자를 위한 키맵핑 (선택사항)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python", 
      callback = function()
        -- 괄호 매칭으로 이동하는 키맵핑
        vim.keymap.set("n", "<leader>rb", "v%", { 
          desc = "Select to matching bracket",
          buffer = true 
        })
        vim.keymap.set("n", "<leader>rB", "va{", { 
          desc = "Select around braces",
          buffer = true 
        })
      end,
    })
  end,
}