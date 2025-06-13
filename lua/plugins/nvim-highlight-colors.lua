return {
  "brenoprata10/nvim-highlight-colors",
  event = "VeryLazy",
  config = function()
    require("nvim-highlight-colors").setup({
      -- 렌더링 모드 설정
      render = "background", -- 'background', 'foreground', 'virtual'
      
      -- 활성화할 색상 포맷들
      enable_hex = true,      -- #RRGGBB
      enable_short_hex = true, -- #RGB  
      enable_rgb = true,      -- rgb(255, 255, 255)
      enable_hsl = true,      -- hsl(150, 30%, 40%)
      enable_var_usage = true, -- CSS 변수 사용 (var(--named-color))
      enable_named_colors = false, -- HTML 색상명 (red, blue 등) - Python에서는 비활성화
      enable_tailwind = false, -- Tailwind CSS 색상 - Python에서는 불필요
      
      -- Python 개발에 특화된 설정
      custom_colors = {
        -- matplotlib 색상
        { label = "%-%-matplotlib%-%-", color = "#11557c" },
        { label = "%-%-seaborn%-%-", color = "#4c72b0" },
        { label = "%-%-plotly%-%-", color = "#636efa" },
      },
      
      -- 제외할 파일 타입들
      exclude_filetypes = {
        "lazy",
        "mason", 
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "notify",
        "toggleterm",
      },
      
      -- 제외할 버퍼 타입들  
      exclude_buftypes = {
        "terminal",
        "nofile",
        "quickfix",
        "prompt",
      },
    })
    
    -- Python에서 색상 관련 패턴을 자동으로 감지
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        -- Python matplotlib/seaborn 색상 패턴 감지 강화
        vim.cmd [[
          syntax match pythonColor /#[0-9A-Fa-f]\{6\}/ containedin=pythonString
          syntax match pythonColor /#[0-9A-Fa-f]\{3\}/ containedin=pythonString  
          syntax match pythonColor /rgb\s*(\s*\d\+\s*,\s*\d\+\s*,\s*\d\+\s*)/ containedin=pythonString
          syntax match pythonColor /rgba\s*(\s*\d\+\s*,\s*\d\+\s*,\s*\d\+\s*,\s*[0-9.]\+\s*)/ containedin=pythonString
        ]]
      end,
    })
  end,
}