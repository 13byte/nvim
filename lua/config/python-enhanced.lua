-- 통합 Python 설정 파일 (인프라 엔지니어링 특화)
-- 모든 Python 관련 플러그인의 공통 설정을 관리
local M = {}

-- Edge 팔레트 로드
local palette = require("config.edge-palette")

-- Python 파일 타입 감지
function M.is_test_file(filepath)
  return filepath:match("test_.*%.py$") or 
         filepath:match("_test%.py$") or
         filepath:match("tests?/.*%.py$") or
         filepath:match("spec_.*%.py$")
end

function M.is_config_file(filepath)
  return filepath:match("config.*%.py$") or 
         filepath:match("settings.*%.py$") or
         filepath:match("conf%.py$") or
         filepath:match(".*_config%.py$")
end

function M.is_main_file(filepath)
  return filepath:match("main%.py$") or 
         filepath:match("__main__%.py$") or
         filepath:match("app%.py$") or
         filepath:match("server%.py$") or
         filepath:match("api%.py$")
end

function M.is_script_file(filepath)
  return filepath:match("deploy%.py$") or
         filepath:match("migrate%.py$") or
         filepath:match("backup%.py$") or
         filepath:match("restore%.py$") or
         filepath:match("setup%.py$")
end

-- 인프라 라이브러리 감지
function M.detect_infra_libraries()
  local lines = vim.api.nvim_buf_get_lines(0, 0, 50, false)
  local libs = {
    aws = false,
    kubernetes = false,
    docker = false,
    terraform = false,
    ansible = false,
    monitoring = false,
    networking = false,
  }
  
  for _, line in ipairs(lines) do
    if line:match("import boto3") or line:match("from boto3") or line:match("from botocore") then
      libs.aws = true
    end
    if line:match("import kubernetes") or line:match("from kubernetes") then
      libs.kubernetes = true
    end
    if line:match("import docker") or line:match("from docker") then
      libs.docker = true
    end
    if line:match("import requests") or line:match("import paramiko") or line:match("import netmiko") then
      libs.networking = true
    end
    if line:match("import prometheus") or line:match("import datadog") or line:match("from cloudwatch") then
      libs.monitoring = true
    end
    if line:match("import ansible") or line:match("from ansible") then
      libs.ansible = true
    end
    if line:match("import terraform") or line:match("from cdktf") then
      libs.terraform = true
    end
  end
  
  return libs
end

-- 통합 Python 설정 적용
function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    group = vim.api.nvim_create_augroup("PythonEnhanced", { clear = true }),
    callback = function()
      local bufname = vim.api.nvim_buf_get_name(0)
      local colors = palette.colors
      
      -- 버퍼 변수 설정
      vim.b.python_file_type = "generic"
      if M.is_test_file(bufname) then
        vim.b.python_file_type = "test"
      elseif M.is_config_file(bufname) then
        vim.b.python_file_type = "config"
      elseif M.is_main_file(bufname) then
        vim.b.python_file_type = "main"
      elseif M.is_script_file(bufname) then
        vim.b.python_file_type = "script"
      end
      
      -- 인프라 라이브러리 감지
      vim.b.python_infra_libs = M.detect_infra_libraries()
      
      -- 공통 하이라이트 설정은 python-syntax.lua로 통합됨
      
      -- 파일 타입별 상태 표시
      local file_type_icon = {
        test = "🧪",
        config = "⚙️",
        main = "🚀",
        script = "📜",
        generic = "📝"
      }
      
      -- 상태 표시 함수 (Lualine이나 다른 곳에서 사용 가능)
      vim.b.python_status = function()
        local ft = vim.b.python_file_type or "generic"
        local icon = file_type_icon[ft]
        local libs = vim.b.python_infra_libs or {}
        local lib_str = ""
        
        for lib, loaded in pairs(libs) do
          if loaded then
            if lib_str ~= "" then lib_str = lib_str .. "," end
            if lib == "aws" then lib_str = lib_str .. "☁️"
            elseif lib == "kubernetes" then lib_str = lib_str .. "☸"
            elseif lib == "docker" then lib_str = lib_str .. "🐳"
            elseif lib == "monitoring" then lib_str = lib_str .. "📊"
            elseif lib == "networking" then lib_str = lib_str .. "🌐"
            else lib_str = lib_str .. lib:sub(1, 2) end
          end
        end
        
        if lib_str ~= "" then
          return string.format("%s [%s]", icon, lib_str)
        else
          return icon
        end
      end
    end,
  })
end

return M