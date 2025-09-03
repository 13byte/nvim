return {
  "sainnhe/edge",
  lazy = false,
  priority = 1000,
  config = function()
    -- Edge Aura 테마 최적화 설정
    vim.g.edge_style = 'aura'
    vim.g.edge_enable_italic = true
    vim.g.edge_disable_italic_comment = false
    vim.g.edge_better_performance = true
    vim.g.edge_transparent_background = 0
    vim.g.edge_dim_foreground = 0
    vim.g.edge_dim_inactive_windows = 0 -- 비활성 창 어둡게 하지 않음
    vim.g.edge_cursor = 'auto'
    vim.g.edge_menu_selection_background = 'blue'
    vim.g.edge_spell_foreground = 'none'
    vim.g.edge_show_eob = 1
    vim.g.edge_float_style = 'bright'
    vim.g.edge_diagnostic_text_highlight = 0
    vim.g.edge_diagnostic_line_highlight = 0
    vim.g.edge_diagnostic_virtual_text = 'colored' -- 'grey' -> 'colored'로 변경
    vim.g.edge_current_word = 'grey background'
    vim.g.edge_inlay_hints_background = 'none'
    vim.g.edge_disable_terminal_colors = 0
    vim.g.edge_lightline_disable_bold = 0 -- Lualine에서도 bold 사용
    
    -- True color 지원
    if vim.fn.has('termguicolors') == 1 then
      vim.opt.termguicolors = true
    end
    
    -- Edge 테마 적용
    vim.cmd.colorscheme('edge')
    
    -- 통합 색상 팔레트 로드
    vim.defer_fn(function()
      require('config.edge-palette').setup()
    end, 50)
    
    -- 추가 커스텀 하이라이트
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('EdgeCustomHighlights', { clear = true }),
      pattern = 'edge',
      callback = function()
        local palette = require('config.edge-palette').colors
        
        -- 더 나은 검색 하이라이트
        vim.api.nvim_set_hl(0, 'Search', { bg = palette.bg_blue, fg = palette.fg, bold = true })
        vim.api.nvim_set_hl(0, 'IncSearch', { bg = palette.bg_purple, fg = palette.fg, bold = true })
        
        -- 더 나은 선택 영역
        vim.api.nvim_set_hl(0, 'Visual', { bg = palette.bg3 })
        vim.api.nvim_set_hl(0, 'VisualNOS', { bg = palette.bg3 })
        
        -- 커서 라인
        vim.api.nvim_set_hl(0, 'CursorLine', { bg = palette.bg1 })
        vim.api.nvim_set_hl(0, 'CursorColumn', { bg = palette.bg1 })
        
        -- 팝업 메뉴
        vim.api.nvim_set_hl(0, 'Pmenu', { bg = palette.bg2, fg = palette.fg })
        vim.api.nvim_set_hl(0, 'PmenuSel', { bg = palette.bg_blue, fg = palette.fg, bold = true })
        
        -- 상태 표시줄
        vim.api.nvim_set_hl(0, 'StatusLine', { bg = palette.bg2, fg = palette.fg })
        vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = palette.bg1, fg = palette.grey })
      end
    })
  end,
}