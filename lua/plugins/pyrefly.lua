return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    local lspconfig = require("lspconfig")
    local configs = require("lspconfig.configs")

    -- pyrefly 커스텀 서버 등록 (공식 지원 전까지)
    if not configs.pyrefly then
      configs.pyrefly = {
        default_config = {
          cmd = { "uv", "run", "pyrefly", "lsp" },
          filetypes = { "python" },
          root_dir = function(fname)
            return lspconfig.util.find_git_ancestor(fname) or vim.loop.os_homedir()
          end,
          settings = {},
          single_file_support = true,
        },
        docs = {
          description = [[
Pyrefly is a fast type checker for Python written in Rust.
]],
        },
      }
    end

    -- 서버 목록에 pyrefly 추가
    opts.servers = opts.servers or {}
    opts.servers.pyrefly = {}

    return opts
  end,
}
