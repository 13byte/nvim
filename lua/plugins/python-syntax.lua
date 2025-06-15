return {
  "vim-python/python-syntax",
  ft = "python",
  config = function()
    vim.g.python_highlight_all = 1 -- 모든 Python 요소 강조

    vim.g.python_highlight_builtins = 1 -- 내장 함수 강조 (len, print 등)
    vim.g.python_highlight_builtin_objs = 1 -- 내장 객체 강조 (True, False, None 등)
    vim.g.python_highlight_builtin_types = 1 -- 내장 타입 강조 (str, int, list 등)
    vim.g.python_highlight_builtin_funcs = 1 -- 내장 함수 강조
    vim.g.python_highlight_builtin_funcs_kwarg = 1 -- 내장 함수 키워드 인수 강조

    vim.g.python_highlight_exceptions = 1 -- 예외 클래스 강조
    vim.g.python_highlight_string_formatting = 1 -- 문자열 포매팅 강조
    vim.g.python_highlight_string_format = 1 -- .format() 메서드 강조
    vim.g.python_highlight_string_templates = 1 -- 템플릿 문자열 강조
    vim.g.python_highlight_indent_errors = 1 -- 인덴테이션 오류 강조
    vim.g.python_highlight_space_errors = 1 -- 공백 오류 강조

    vim.g.python_highlight_doctests = 1 -- doctest 강조
    vim.g.python_highlight_func_calls = 1 -- 함수 호출 강조
    vim.g.python_highlight_class_vars = 1 -- 클래스 변수 강조
    vim.g.python_highlight_operators = 1 -- 연산자 강조

    vim.g.python_highlight_type_annotations = 1 -- 타입 어노테이션
    vim.g.python_highlight_union_types = 1 -- Union 타입
    vim.g.python_highlight_generic_types = 1 -- Generic 타입

    vim.g.python_highlight_async_await = 1 -- async/await 강조
    vim.g.python_highlight_generators = 1 -- 제너레이터 강조

    vim.g.python_highlight_walrus_operator = 1 -- := 연산자 (3.8)
    vim.g.python_highlight_positional_only = 1 -- / 매개변수 (3.8)
    vim.g.python_highlight_pattern_matching = 1 -- match/case (3.10+)

    vim.g.python_highlight_file_headers_as_comments = 1 -- 파일 헤더를 주석으로 처리

    vim.g.python_version_2 = 0 -- Python 2 비활성화

    vim.g.python_slow_sync = 1
    vim.g.python_highlight_space_errors = 0
    vim.g.python_highlight_indent_errors = 0

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        vim.cmd([[
          syntax region pythonFString start=+[fF]'+ skip=+\\\\\|\\'\|\\$+ end=+'+ contains=pythonFStringConversion,pythonFStringFormat,pythonFStringSpec
          syntax region pythonFString start=+[fF]"+ skip=+\\\\\|\\"\|\\$+ end=+"+ contains=pythonFStringConversion,pythonFStringFormat,pythonFStringSpec
          
          syntax match pythonDecorator "@\w\+" display nextgroup=pythonDecoratorName skipwhite
          
          syntax keyword pythonAsyncAwait async await
          hi def link pythonAsyncAwait Statement
          
          syntax match pythonTypeHint /:\s*\w\+/ contains=pythonBuiltinType
          syntax match pythonTypeHint /:\s*List\[\w\+\]/ contains=pythonBuiltinType
          syntax match pythonTypeHint /:\s*Dict\[\w\+,\s*\w\+\]/ contains=pythonBuiltinType
          syntax match pythonTypeHint /:\s*Optional\[\w\+\]/ contains=pythonBuiltinType
          syntax match pythonTypeHint /:\s*Union\[.*\]/ contains=pythonBuiltinType
          hi def link pythonTypeHint Type
          
          syntax match pythonWalrusOperator /:=/ 
          hi def link pythonWalrusOperator Operator
          
          syntax keyword pythonMatchCase match case
          hi def link pythonMatchCase Conditional
        ]])

        vim.cmd([[
          syntax keyword pythonDataScience pandas numpy matplotlib seaborn sklearn scipy jupyter ipython
          syntax keyword pythonDataScience pd np plt sns sk tf keras torch
          syntax keyword pythonDataScience DataFrame Series Array tensor
          hi def link pythonDataScience Identifier
          
          syntax keyword pythonML fit predict transform train_test_split cross_val_score
          syntax keyword pythonML LinearRegression LogisticRegression RandomForestClassifier
          syntax keyword pythonML accuracy_score precision_score recall_score f1_score
          hi def link pythonML Function
          
          syntax keyword pythonDataMethods groupby merge concat pivot_table agg apply map
          syntax keyword pythonDataMethods dropna fillna isna reset_index set_index
          syntax keyword pythonDataMethods head tail describe info shape columns dtypes
          hi def link pythonDataMethods Method
          
          syntax keyword pythonVisualization plot scatter hist boxplot heatmap pairplot
          syntax keyword pythonVisualization figure subplot xlabel ylabel title legend
          syntax keyword pythonVisualization show savefig tight_layout
          hi def link pythonVisualization Function
        ]])

        vim.keymap.set("n", "<leader>ph", function()
          local python_help = {
            "🐍 Python 최신 기능 가이드:",
            "• Type Hints: def func(x: int) -> str:",
            "• Walrus Operator: if (n := len(items)) > 5:",
            "• Pattern Matching: match value: case 1: ...",
            "• f-strings: f'{name=}' f'{value:.2f}'",
            "• Async: async def func(): await other()",
            "• Data Science: df.groupby('col').agg({'col2': 'mean'})",
          }
          vim.notify(table.concat(python_help, "\n"), vim.log.levels.INFO)
        end, { desc = "Show Python syntax guide", buffer = true })
      end,
    })
  end,
}

