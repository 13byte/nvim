return {
  "sainnhe/edge",
  lazy = false,
  priority = 1000,
  config = function()
    -- Edge 테마 설정
    vim.g.edge_style = 'aura'                    -- Dark(Aura) 스타일 적용
    vim.g.edge_enable_italic = true              -- 이탤릭 활성화
    vim.g.edge_disable_italic_comment = false    -- 주석 이탤릭 유지
    vim.g.edge_better_performance = true         -- 성능 최적화
    vim.g.edge_transparent_background = 0        -- 투명 배경 비활성화
    vim.g.edge_dim_foreground = 0                -- 일반 전경색 사용
    vim.g.edge_cursor = 'auto'                   -- 자동 커서 색상
    vim.g.edge_menu_selection_background = 'blue'-- 메뉴 선택 배경색
    vim.g.edge_spell_foreground = 'none'         -- 맞춤법 검사 전경색
    vim.g.edge_show_eob = 1                      -- 버퍼 끝 표시
    vim.g.edge_float_style = 'bright'            -- 플로팅 윈도우 스타일
    vim.g.edge_diagnostic_text_highlight = 0     -- 진단 텍스트 하이라이트
    vim.g.edge_diagnostic_line_highlight = 0     -- 진단 라인 하이라이트
    vim.g.edge_diagnostic_virtual_text = 'grey'  -- 가상 텍스트 스타일
    vim.g.edge_current_word = 'grey background'  -- 현재 단어 하이라이트
    vim.g.edge_inlay_hints_background = 'none'   -- 인레이 힌트 배경
    vim.g.edge_disable_terminal_colors = 0       -- 터미널 색상 활성화
    
    -- True color 지원 확인 및 활성화
    if vim.fn.has('termguicolors') == 1 then
      vim.opt.termguicolors = true
    end
    
    -- Edge 테마 적용
    vim.cmd.colorscheme('edge')
    
    -- 커스텀 하이라이트 설정 (선택사항)
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('EdgeCustomHighlights', {}),
      pattern = 'edge',
      callback = function()
        -- 추가적인 커스텀 하이라이트가 필요하면 여기에 추가
        -- 예: vim.api.nvim_set_hl(0, 'Search', { bg = '#4A5D75' })
      end
    })
  end,
}