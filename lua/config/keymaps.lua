-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

function Map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

vim.g.mapleader = " "

Map("n", "<A-Up>", ":resize -2<CR>") -- 수평 창 높이 감소
Map("n", "<A-Down>", ":resize +2<CR>") -- 수평 창 높이 증가
Map("n", "<A-Right>", ":vertical resize -2<CR>") -- 수직 창 너비 감소
Map("n", "<A-Left>", ":vertical resize +2<CR>") -- 수직 창 너비 증가

Map("t", "<A-Down>", "<cmd>resize -2<CR>")
Map("t", "<A-Up>", "<cmd>resize +2<CR>")
Map("t", "<A-Right>", "<cmd>vertical resize -2<CR>")
Map("t", "<A-Left>", "<cmd>vertical resize +2<CR>")
