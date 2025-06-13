return {
  "m-demare/hlargs.nvim",
  event = "VeryLazy",
  config = function()
    require("hlargs").setup({
      color = "#ef9062", -- 기본 인수 색상 (주황색)
      highlight = {}, -- 기본 하이라이트 그룹 사용
      excluded_filetypes = {}, -- 제외할 파일 타입
      -- Python에 특화된 설정
      paint_arg_declarations = true, -- 함수 선언부의 인수 강조
      paint_arg_usages = true, -- 함수 사용부의 인수 강조
      paint_catch_per_args = false, -- catch 블록 인수 강조 (Python에서는 불필요)
      extras = {
        named_parameters = false, -- 명명된 매개변수 강조 (Python kwargs 등)
      },
      hl_priority = 10000, -- 하이라이팅 우선순위
      excluded_argnames = {
        declarations = {}, -- 선언부에서 제외할 인수명
        usages = {
          python = { "self", "cls" }, -- Python에서 self, cls는 제외
        },
      },
      performance = {
        parse_delay = 1, -- 파싱 지연 시간 (ms)
        slow_parse_delay = 50, -- 큰 파일에서의 지연 시간
        max_iterations = 400, -- 최대 반복 횟수
        max_concurrent_partial_parses = 30, -- 동시 부분 파싱 수
        debounce = {
          partial_parse = 3, -- 부분 파싱 디바운스
          full_parse = 50, -- 전체 파싱 디바운스
        },
      },
    })
  end,
}