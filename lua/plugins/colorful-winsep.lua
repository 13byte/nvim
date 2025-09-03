return {
  "nvim-zh/colorful-winsep.nvim",
  event = "WinNew",
  enabled = true,
  dependencies = { "sainnhe/edge" },
  config = function()
    -- Edge 팔레트 로드
    local palette = require("config.edge-palette")
    
    require("colorful-winsep").setup({
      -- Edge Aura 테마와 일치하는 색상
      hi = {
        bg = palette.colors.bg0,
        fg = palette.colors.blue, -- 기본 파란색
      },
      
      -- 충돌 방지를 위한 파일타입 제외
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
        "AvanteInput",
        "noice",
        "notify",
        "trouble",
        "Trouble",
        "help",
        "qf",
        "fugitive",
        "gitcommit",
      },
      
      -- 구분선 심볼
      symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
      
      -- 부드러운 애니메이션
      only_line_seq = true,
      smooth = true,
      exponential_smoothing = true,
      
      -- 앵커 설정
      anchor = {
        left = { height = 1, x = -1, y = -1 },
        right = { height = 1, x = -1, y = 0 },
        up = { width = 0, x = -1, y = 0 },
        bottom = { width = 0, x = 1, y = 0 },
      },
    })
    
    -- 파일 타입에 따른 색상 변경 (python-enhanced에서 관리하는 정보 활용)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      group = vim.api.nvim_create_augroup("WinsepColor", { clear = true }),
      callback = function()
        vim.defer_fn(function()
          local file_type = vim.b.python_file_type or "generic"
          local color_map = {
            test = palette.colors.red,
            config = palette.colors.yellow,
            main = palette.colors.green,
            generic = palette.colors.blue,
          }
          
          vim.api.nvim_set_hl(0, "NvimSeparator", {
            fg = color_map[file_type],
            bg = palette.colors.bg0
          })
        end, 100)
      end,
    })
  end,
}