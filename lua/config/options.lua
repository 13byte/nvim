-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Python LSP로 pyrefly만 사용
vim.g.lazyvim_python_lsp = "pyrefly"
-- Python formatter(포매터)로 ruff만 사용
vim.g.lazyvim_python_ruff = "ruff"
