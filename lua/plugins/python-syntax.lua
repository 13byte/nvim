return {
  "vim-python/python-syntax",
  ft = "python", -- Python 파일에서만 로드
  config = function()
    -- Python 구문 강조 세부 설정
    vim.g.python_highlight_all = 1 -- 모든 Python 요소 강조
    
    -- 개별 요소별 강조 설정 (세밀한 제어)
    vim.g.python_highlight_builtins = 1           -- 내장 함수 강조 (len, print 등)
    vim.g.python_highlight_builtin_objs = 1       -- 내장 객체 강조 (True, False, None 등)
    vim.g.python_highlight_builtin_types = 1      -- 내장 타입 강조 (str, int, list 등)
    vim.g.python_highlight_builtin_funcs = 1      -- 내장 함수 강조
    vim.g.python_highlight_builtin_funcs_kwarg = 1 -- 내장 함수 키워드 인수 강조
    
    -- 고급 Python 기능 강조
    vim.g.python_highlight_exceptions = 1         -- 예외 클래스 강조
    vim.g.python_highlight_string_formatting = 1  -- 문자열 포매팅 강조
    vim.g.python_highlight_string_format = 1      -- .format() 메서드 강조
    vim.g.python_highlight_string_templates = 1   -- 템플릿 문자열 강조
    vim.g.python_highlight_indent_errors = 1      -- 인덴테이션 오류 강조
    vim.g.python_highlight_space_errors = 1       -- 공백 오류 강조
    
    -- 최신 Python 기능 강조
    vim.g.python_highlight_doctests = 1           -- doctest 강조
    vim.g.python_highlight_func_calls = 1         -- 함수 호출 강조
    vim.g.python_highlight_class_vars = 1         -- 클래스 변수 강조
    vim.g.python_highlight_operators = 1          -- 연산자 강조
    
    -- f-strings 및 최신 문법 강조
    vim.g.python_highlight_file_headers_as_comments = 1 -- 파일 헤더를 주석으로 처리
    
    -- Python 3.6+ 기능 활성화
    vim.g.python_version_2 = 0 -- Python 2 비활성화
    
    -- 성능 최적화 설정
    vim.g.python_slow_sync = 1 -- 큰 파일에서의 동기화 개선
    
    -- 추가 커스텀 하이라이팅
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        -- Python에 특화된 추가 하이라이팅 규칙
        vim.cmd [[
          " f-strings 강조 개선
          syntax region pythonFString start=+[fF]'+ skip=+\\\\\|\\'\|\\$+ end=+'+ contains=pythonFStringConversion,pythonFStringFormat,pythonFStringSpec
          syntax region pythonFString start=+[fF]"+ skip=+\\\\\|\\"\|\\$+ end=+"+ contains=pythonFStringConversion,pythonFStringFormat,pythonFStringSpec
          
          " 데코레이터 강조 개선
          syntax match pythonDecorator "@\w\+" display nextgroup=pythonDecoratorName skipwhite
          
          " async/await 키워드 강조
          syntax keyword pythonAsyncAwait async await
          hi def link pythonAsyncAwait Statement
          
          " Type hints 강조
          syntax match pythonTypeHint /:\s*\w\+/ contains=pythonBuiltinType
          hi def link pythonTypeHint Type
        ]]
      end,
    })
  end,
}