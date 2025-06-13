return {
  "m-demare/hlargs.nvim",
  event = "VeryLazy",
  config = function()
    require("hlargs").setup({
      -- 💡 더 세밀한 색상 구분
      color = {
        func_args = "#ef9062",     -- 함수 인수 (주황)
        func_kwargs = "#d19a66",   -- 키워드 인수 (갈색)
        builtin_args = "#98c379",  -- 내장함수 인수 (초록)
      },
      
      highlight = {}, -- 기본 하이라이트 그룹 사용
      excluded_filetypes = {}, -- 제외할 파일 타입
      
      -- Python에 특화된 설정
      paint_arg_declarations = true, -- 함수 선언부의 인수 강조
      paint_arg_usages = true, -- 함수 사용부의 인수 강조
      paint_catch_per_args = false, -- catch 블록 인수 강조 (Python에서는 불필요)
      
      extras = {
        named_parameters = true, -- 명명된 매개변수 강조 (Python kwargs 등)
      },
      
      hl_priority = 10000, -- 하이라이팅 우선순위
      
      -- 💡 Python 특화 제외 패턴 강화
      excluded_argnames = {
        declarations = {}, -- 선언부에서 제외할 인수명
        usages = {
          python = { 
            "self", "cls", "args", "kwargs", 
            "__init__", "__new__", "__call__",  -- 매직 메서드도 제외
            "__enter__", "__exit__", "__iter__", "__next__" -- 추가 매직 메서드
          },
        },
      },
      
      -- 💡 성능 최적화 (대용량 Python 파일용)
      performance = {
        parse_delay = 1, -- 파싱 지연 시간 (ms)
        slow_parse_delay = 25, -- 더 빠른 반응성 (큰 파일에서)
        max_iterations = 800, -- 큰 Python 클래스용 (기존 400 → 800)
        max_concurrent_partial_parses = 50, -- 동시 부분 파싱 수 증가
        debounce = {
          partial_parse = 2, -- 부분 파싱 디바운스 감소 (더 빠른 반응)
          full_parse = 30, -- 전체 파싱 디바운스 감소
        },
      },
      
      -- Python 특화 추가 설정
      use_colorpalette = true, -- 색상 팔레트 사용
      disable_default_highlighting = false, -- 기본 하이라이팅 유지
    })
    
    -- Python 파일에서 추가 하이라이팅 규칙
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        -- Python 데이터 사이언스 함수들을 위한 특별 색상
        vim.cmd [[
          " pandas/numpy 함수 인수 특별 강조
          hi def hlargsPandasArgs guifg=#56B6C2 ctermfg=38
          hi def hlargsNumpyArgs guifg=#C678DD ctermfg=170
          
          " 람다 함수 인수 강조
          hi def hlargsLambdaArgs guifg=#E5C07B ctermfg=180
        ]]
      end,
    })
  end,
}