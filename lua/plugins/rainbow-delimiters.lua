return {
  "HiPhish/rainbow-delimiters.nvim",
  event = "VeryLazy",
  config = function()
    local rainbow_delimiters = require("rainbow-delimiters")
    
    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rainbow_delimiters.strategy["global"], -- 기본 전략
        python = rainbow_delimiters.strategy["local"], -- Python은 로컬 전략 사용
      },
      query = {
        [""] = "rainbow-delimiters", -- 기본 쿼리
        python = "rainbow-delimiters", -- Python 쿼리
      },
      priority = {
        [""] = 110, -- 기본 우선순위
        python = 110, -- Python 우선순위
      },
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow", 
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      },
      blacklist = {}, -- 비활성화할 언어들
      whitelist = { "python", "lua", "javascript", "typescript", "json", "yaml" }, -- 활성화할 언어들
    }
    
    -- Python에 특화된 추가 설정
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        -- Python에서 특별히 강조할 구문들
        vim.cmd [[
          hi def RainbowDelimiterRed    guifg=#E06C75 ctermfg=204
          hi def RainbowDelimiterYellow guifg=#E5C07B ctermfg=180  
          hi def RainbowDelimiterBlue   guifg=#61AFEF ctermfg=39
          hi def RainbowDelimiterOrange guifg=#D19A66 ctermfg=173
          hi def RainbowDelimiterGreen  guifg=#98C379 ctermfg=114
          hi def RainbowDelimiterViolet guifg=#C678DD ctermfg=170
          hi def RainbowDelimiterCyan   guifg=#56B6C2 ctermfg=38
        ]]
      end,
    })
  end,
}