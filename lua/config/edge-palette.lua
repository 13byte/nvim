-- Edge Aura 테마 통합 색상 팔레트 (인프라 엔지니어링 특화)
-- 모든 플러그인에서 일관된 색상 사용을 위한 중앙 관리
local M = {}

-- Edge Aura 공식 색상 팔레트
M.colors = {
  -- 배경 색상
  black = "#202023",
  bg_dim = "#24262d",
  bg0 = "#2b2d37",
  bg1 = "#333644",
  bg2 = "#363a49",
  bg3 = "#3a3e4e",
  bg4 = "#404455",
  
  -- 기본 색상
  fg = "#c5cdd9",
  grey = "#758094",
  grey_dim = "#535c6a",
  bg_grey = "#7e869b",
  
  -- 주요 색상
  red = "#ec7279",
  yellow = "#deb974",
  green = "#a0c980",
  cyan = "#5dbbc1",
  blue = "#6cb6eb",
  purple = "#d38aea",
  orange = "#ef9062",
  
  -- 배경 하이라이트 색상
  bg_red = "#55393d",
  bg_yellow = "#4e432f",
  bg_green = "#394634",
  bg_blue = "#354157",
  bg_purple = "#483b55",
  
  -- 채워진 색상 (더 진한 버전)
  filled_red = "#ec7279",
  filled_green = "#a0c980",
  filled_blue = "#6cb6eb",
  filled_purple = "#d38aea",
}

-- 의미론적 색상 매핑
M.semantic = {
  -- 구문 하이라이팅
  keyword = M.colors.purple,
  func = M.colors.blue,
  string = M.colors.green,
  number = M.colors.orange,
  comment = M.colors.grey,
  type = M.colors.yellow,
  variable = M.colors.fg,
  
  -- 진단
  error = M.colors.red,
  warning = M.colors.yellow,
  info = M.colors.cyan,
  hint = M.colors.purple,
  
  -- Git
  added = M.colors.green,
  modified = M.colors.yellow,
  removed = M.colors.red,
  
  -- 특수 용도
  selection = M.colors.bg3,
  match = M.colors.bg_blue,
  diff_add = M.colors.bg_green,
  diff_delete = M.colors.bg_red,
  diff_change = M.colors.bg_yellow,
}

-- Rainbow delimiters 10단계 색상
M.rainbow = {
  M.colors.red,
  M.colors.yellow,
  M.colors.blue,
  M.colors.orange,
  M.colors.green,
  M.colors.purple,
  M.colors.cyan,
  "#ff79c6", -- 핑크
  M.colors.grey,
  "#87ceeb", -- 라이트 블루
}

-- Python 특화 색상 (인프라 엔지니어링)
M.python = {
  -- 인프라 관련
  cloud = M.colors.cyan,
  networking = M.colors.blue,
  monitoring = M.colors.green,
  devops = M.colors.purple,
  system = M.colors.yellow,
  security = M.colors.red,
}

-- 시간대별 색상 (colorful-winsep)
M.time_based = {
  morning = M.colors.green,   -- 06:00-12:00
  afternoon = M.colors.blue,  -- 12:00-18:00
  evening = M.colors.purple,  -- 18:00-06:00
}

-- 색상 적용 함수
function M.setup()
  -- 전역 변수로 색상 팔레트 노출
  _G.EdgePalette = M.colors
  _G.EdgeSemantic = M.semantic
  
  -- Neovim 하이라이트 그룹 설정
  local highlights = {
    -- Rainbow Delimiters
    RainbowDelimiterRed = { fg = M.rainbow[1] },
    RainbowDelimiterYellow = { fg = M.rainbow[2] },
    RainbowDelimiterBlue = { fg = M.rainbow[3] },
    RainbowDelimiterOrange = { fg = M.rainbow[4] },
    RainbowDelimiterGreen = { fg = M.rainbow[5] },
    RainbowDelimiterViolet = { fg = M.rainbow[6] },
    RainbowDelimiterCyan = { fg = M.rainbow[7] },
    RainbowDelimiterPink = { fg = M.rainbow[8] },
    RainbowDelimiterGray = { fg = M.rainbow[9] },
    RainbowDelimiterLightBlue = { fg = M.rainbow[10] },
    
    -- 인프라 특화
    PythonInfraCloud = { fg = M.python.cloud },
    PythonNetworking = { fg = M.python.networking },
    PythonMonitoring = { fg = M.python.monitoring },
    PythonDevOps = { fg = M.python.devops },
    PythonSystem = { fg = M.python.system },
    PythonSecurity = { fg = M.python.security },
  }
  
  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

return M