-- 인프라 엔지니어링 특화 Python 구문 하이라이팅
return {
  {
    "vim-python/python-syntax",
    ft = "python",
    dependencies = { "sainnhe/edge" },
    config = function()
      -- Edge 팔레트 로드
      local palette = require("config.edge-palette")
      
      -- Python 구문 하이라이팅 전체 활성화
      vim.g.python_highlight_all = 1
      vim.g.python_highlight_builtins = 1
      vim.g.python_highlight_builtin_objs = 1
      vim.g.python_highlight_builtin_types = 1
      vim.g.python_highlight_builtin_funcs = 1
      vim.g.python_highlight_builtin_funcs_kwarg = 1
      vim.g.python_highlight_exceptions = 1
      vim.g.python_highlight_string_formatting = 1
      vim.g.python_highlight_string_format = 1
      vim.g.python_highlight_string_templates = 1
      vim.g.python_highlight_doctests = 1
      vim.g.python_highlight_func_calls = 1
      vim.g.python_highlight_class_vars = 1
      vim.g.python_highlight_operators = 1
      vim.g.python_highlight_file_headers_as_comments = 1
      
      -- 최신 Python 기능
      vim.g.python_highlight_async_await = 1
      vim.g.python_highlight_generators = 1
      vim.g.python_version_2 = 0
      
      -- 성능 설정
      vim.g.python_slow_sync = 0
      vim.g.python_highlight_space_errors = 0
      vim.g.python_highlight_indent_errors = 0
    end,
  },
  
  {
    "m-demare/hlargs.nvim",
    ft = "python",
    dependencies = { 
      "sainnhe/edge",
      "nvim-treesitter/nvim-treesitter"
    },
    config = function()
      -- Edge 팔레트 로드
      local palette = require("config.edge-palette")
      
      require("hlargs").setup({
        -- Edge 테마와 통합된 색상
        color = palette.colors.orange,
        
        highlight = {},
        excluded_filetypes = {
          "TelescopePrompt",
          "lazy",
          "mason",
          "neo-tree",
          "dashboard",
        },
        
        -- Python 특화 설정
        paint_arg_declarations = true,
        paint_arg_usages = true,
        paint_catch_per_args = false,
        
        extras = {
          named_parameters = true,
        },
        
        hl_priority = 10000,
        
        -- Python 매직 메서드 제외
        excluded_argnames = {
          declarations = {},
          usages = {
            python = { 
              "self", "cls", "args", "kwargs",
              "__init__", "__new__", "__call__",
              "__enter__", "__exit__", "__iter__", "__next__",
              "__getattr__", "__setattr__", "__delattr__",
              "__getitem__", "__setitem__", "__delitem__",
              "__str__", "__repr__", "__format__",
              "__bool__", "__len__", "__contains__",
              "__eq__", "__ne__", "__lt__", "__le__", "__gt__", "__ge__",
              "__hash__", "__bytes__", "__copy__", "__deepcopy__",
            },
          },
        },
        
        -- 성능 최적화
        performance = {
          parse_delay = 1,
          slow_parse_delay = 20,
          max_iterations = 1000,
          max_concurrent_partial_parses = 50,
          debounce = {
            partial_parse = 3,
            full_parse = 30,
          },
        },
        
        use_colorpalette = false,
        disable_default_highlighting = false,
      })
      
      -- 인프라 엔지니어링 특화 하이라이트
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        group = vim.api.nvim_create_augroup("PythonInfra", { clear = true }),
        once = true,
        callback = function()
          local colors = palette.colors
          
          -- hlargs 색상 설정
          vim.api.nvim_set_hl(0, "Hlargs", { fg = palette.colors.orange })
          
          -- Python 핵심 하이라이트 설정
          vim.cmd(string.format('hi pythonTypeAnnotation guifg=%s gui=italic', colors.yellow))
          vim.cmd(string.format('hi pythonReturnType guifg=%s gui=italic', colors.yellow))
          vim.cmd(string.format('hi pythonDecorator guifg=%s gui=italic', colors.purple))
          vim.cmd(string.format('hi pythonMagicMethod guifg=%s gui=italic', colors.orange))
          vim.cmd(string.format('hi pythonConstant guifg=%s gui=bold', colors.orange))
          vim.cmd(string.format('hi pythonFString guifg=%s', colors.green))
          vim.cmd(string.format('hi pythonFStringInterpolation guifg=%s gui=bold', colors.yellow))
          vim.cmd(string.format('hi pythonAsyncAwait guifg=%s gui=bold', colors.purple))
          vim.cmd(string.format('hi pythonMatchCase guifg=%s gui=bold', colors.purple))
          
          -- 인프라 엔지니어링 키워드
          vim.cmd([[
            " 클라우드 SDK & 인프라 도구
            syntax keyword pythonInfraCloud boto3 botocore aws azure gcp google
            syntax keyword pythonInfraCloud ec2 s3 lambda sqs sns dynamodb rds ecs eks fargate
            syntax keyword pythonInfraCloud kubernetes docker terraform ansible packer vault consul
            
            " 네트워킹 & API
            syntax keyword pythonNetworking requests urllib httpx aiohttp fastapi flask django
            syntax keyword pythonNetworking socket paramiko netmiko napalm pysnmp
            syntax keyword pythonNetworking asyncio threading multiprocessing concurrent
            
            " 모니터링 & 로깅
            syntax keyword pythonMonitoring prometheus datadog newrelic grafana cloudwatch
            syntax keyword pythonMonitoring logging logger loguru structlog json yaml toml
            syntax keyword pythonMonitoring metrics alerts threshold baseline anomaly
            
            " DevOps & CI/CD
            syntax keyword pythonDevOps jenkins gitlab github actions pipeline build deploy
            syntax keyword pythonDevOps docker compose swarm registry image container pod
            syntax keyword pythonDevOps helm chart configmap secret ingress service deployment
            
            " 시스템 & OS
            syntax keyword pythonSystem os sys subprocess shutil pathlib psutil platform
            syntax keyword pythonSystem systemd cron schedule celery redis rabbitmq kafka
            syntax keyword pythonSystem cpu memory disk network process thread signal
            
            " 보안 & 암호화
            syntax keyword pythonSecurity cryptography hashlib hmac jwt oauth ssl tls
            syntax keyword pythonSecurity encrypt decrypt hash token auth permission role
            syntax keyword pythonSecurity firewall iptables security audit compliance
          ]])
          
          -- 인프라 키워드 색상 설정
          vim.cmd(string.format('hi pythonInfraCloud guifg=%s gui=bold', colors.cyan))
          vim.cmd(string.format('hi pythonNetworking guifg=%s gui=bold', colors.blue))
          vim.cmd(string.format('hi pythonMonitoring guifg=%s', colors.green))
          vim.cmd(string.format('hi pythonDevOps guifg=%s', colors.purple))
          vim.cmd(string.format('hi pythonSystem guifg=%s', colors.yellow))
          vim.cmd(string.format('hi pythonSecurity guifg=%s gui=italic', colors.red))
          vim.cmd(string.format('hi pythonEnvVar guifg=%s gui=bold', colors.orange))
          vim.cmd(string.format('hi pythonConfigFile guifg=%s gui=underline', colors.purple))
        end,
      })
    end,
  },
}