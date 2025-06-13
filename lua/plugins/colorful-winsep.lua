return {
  "nvim-zh/colorful-winsep.nvim",
  event = "WinNew",
  enabled = true, -- 필요시 false로 변경하여 비활성화 가능
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
        "noice", -- noice.nvim과 충돌 방지
        "notify",
      },
      
      -- 구분선 심볼
      symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
      
      -- 안전한 기본 설정만 사용
      only_line_seq = true,
      smooth = false, -- 애니메이션 비활성화 (안정성 향상)
      exponential_smoothing = false,
      
      -- 기본 앵커 설정
      anchor = {
        left = { height = 1, x = -1, y = -1 },
        right = { height = 1, x = -1, y = 0 },
        up = { width = 0, x = -1, y = 0 },
        bottom = { width = 0, x = 1, y = 0 },
      },
    })
  end,
}