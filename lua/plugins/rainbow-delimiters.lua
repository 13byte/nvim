return {
  "HiPhish/rainbow-delimiters.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "sainnhe/edge" },
  config = function()
    -- Edge 팔레트 로드
    local palette = require("config.edge-palette")
    local rainbow_delimiters = require("rainbow-delimiters")
    
    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rainbow_delimiters.strategy["global"],
        vim = rainbow_delimiters.strategy["local"],
        html = rainbow_delimiters.strategy["local"],
        python = rainbow_delimiters.strategy["local"], -- Python 성능 최적화
      },
      
      query = {
        [""] = "rainbow-delimiters",
        latex = "rainbow-blocks",
      },
      
      priority = {
        [""] = 110,
        python = 120, -- Python 우선순위 높임
      },
      
      -- Edge 테마 기반 10단계 색상
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
        "RainbowDelimiterPink",
        "RainbowDelimiterGray",
        "RainbowDelimiterLightBlue",
      },
      
      blacklist = {
        "help",
        "dashboard",
        "lazy",
        "mason",
        "neo-tree",
        "notify",
        "trouble",
      },
    }
    
    -- Edge 테마 색상 적용 (통합 팔레트 사용)
    vim.defer_fn(function()
      local colors = palette.rainbow
      for i, color in ipairs(colors) do
        local group_name = vim.g.rainbow_delimiters.highlight[i]
        if group_name then
          vim.api.nvim_set_hl(0, group_name, { fg = color, bold = true })
        end
      end
    end, 100)
  end,
}