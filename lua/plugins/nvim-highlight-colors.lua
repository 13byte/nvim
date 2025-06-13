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
      
      -- 💡 Python 주석에서도 색상 감지
      include_comments = true,
      
      -- 💡 Python 데이터 시각화 라이브러리 특화
      custom_colors = {
        -- matplotlib/seaborn 색상맵
        { label = "viridis", color = "#440154" },
        { label = "plasma", color = "#0d0887" },
        { label = "inferno", color = "#000004" },
        { label = "magma", color = "#000004" },
        { label = "cividis", color = "#00204d" },
        
        -- plotly 기본 색상 팔레트
        { label = "plotly_blue", color = "#636efa" },
        { label = "plotly_red", color = "#ef553b" },
        { label = "plotly_green", color = "#00cc96" },
        { label = "plotly_orange", color = "#ff6692" },
        { label = "plotly_purple", color = "#ab63fa" },
        
        -- 과학 시각화 표준 색상 (matplotlib 기본)
        { label = "scientific_blue", color = "#1f77b4" },
        { label = "scientific_orange", color = "#ff7f0e" },
        { label = "scientific_green", color = "#2ca02c" },
        { label = "scientific_red", color = "#d62728" },
        { label = "scientific_purple", color = "#9467bd" },
        
        -- seaborn 색상 팔레트
        { label = "seaborn_blue", color = "#4c72b0" },
        { label = "seaborn_orange", color = "#dd8452" },
        { label = "seaborn_green", color = "#55a868" },
        { label = "seaborn_red", color = "#c44e52" },
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
    
    -- 💡 더 정확한 Python 색상 패턴 감지
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        -- Python matplotlib/seaborn 색상 패턴 감지 강화
        vim.cmd [[
          " 기본 색상 패턴
          syntax match pythonColor /#[0-9A-Fa-f]\{6\}/ containedin=pythonString
          syntax match pythonColor /#[0-9A-Fa-f]\{3\}/ containedin=pythonString
          
          " RGB/RGBA 패턴 (함수 호출 형태)
          syntax match pythonColor /rgb\s*(\s*\d\+\s*,\s*\d\+\s*,\s*\d\+\s*)/ containedin=pythonString
          syntax match pythonColor /rgba\s*(\s*\d\+\s*,\s*\d\+\s*,\s*\d\+\s*,\s*[0-9.]\+\s*)/ containedin=pythonString
          
          " HSL 패턴
          syntax match pythonColor /hsl\s*(\s*\d\+\s*,\s*\d\+%\s*,\s*\d\+%\s*)/ containedin=pythonString
          
          " matplotlib 색상명 패턴 (문자열 내)
          syntax match pythonColor /'#[0-9A-Fa-f]\{6\}'/ containedin=pythonString
          syntax match pythonColor /"#[0-9A-Fa-f]\{6\}"/ containedin=pythonString
          
          " 16진수 색상 (0x 형태)
          syntax match pythonColor /0x[0-9A-Fa-f]\{6\}/ containedin=pythonString
          
          " 주석 내 색상 코드도 감지
          syntax match pythonColor /#[0-9A-Fa-f]\{6\}/ containedin=pythonComment
          syntax match pythonColor /#[0-9A-Fa-f]\{3\}/ containedin=pythonComment
        ]]
        
        -- Python 데이터 시각화 작업 시 도움말 표시
        vim.keymap.set("n", "<leader>cc", function()
          local colors_help = {
            "🎨 Python 색상 코드 가이드:",
            "matplotlib: plt.plot(color='#1f77b4')",
            "seaborn: sns.set_palette(['#4c72b0', '#dd8452'])",
            "plotly: fig.update_traces(marker_color='#636efa')",
            "RGB: color=(255, 127, 14) 또는 'rgb(255,127,14)'",
            "HEX: '#ff7f0e' 또는 0xff7f0e",
          }
          vim.notify(table.concat(colors_help, "\n"), vim.log.levels.INFO)
        end, { desc = "Show Python color guide", buffer = true })
      end,
    })
  end,
}