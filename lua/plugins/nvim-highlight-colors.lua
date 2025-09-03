return {
  "brenoprata10/nvim-highlight-colors",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "sainnhe/edge" },
  config = function()
    require("nvim-highlight-colors").setup({
      -- 렌더링 모드
      render = "background", -- 배경색으로 표시
      
      -- 색상 포맷 활성화 (색상 미리보기에만 집중)
      enable_hex = true,       -- #RRGGBB
      enable_short_hex = true, -- #RGB
      enable_rgb = true,       -- rgb(255, 255, 255)
      enable_hsl = true,       -- hsl(150, 30%, 40%)
      enable_var_usage = false, -- CSS 변수 비활성화
      enable_named_colors = false, -- HTML 색상명 비활성화
      enable_tailwind = false,     -- Tailwind 비활성화
      
      -- 주석에서도 색상 감지
      include_comments = true,
      
      -- 제외할 파일 타입
      exclude_filetypes = {
        "lazy",
        "mason",
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "NvimTree",
        "Trouble",
        "trouble",
        "notify",
        "toggleterm",
        "TelescopePrompt",
        "qf",
        "lspinfo",
        "checkhealth",
      },
      
      -- 제외할 버퍼 타입
      exclude_buftypes = {
        "terminal",
        "nofile",
        "quickfix",
        "prompt",
      },
    })
  end,
}