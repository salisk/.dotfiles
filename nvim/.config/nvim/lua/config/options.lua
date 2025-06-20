-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
opt.iskeyword:append("-") -- consider string-string as whole word

-- Ruby overrides
-- vim.g.lazyvim_ruby_lsp = "solargraph"
-- vim.g.lazyvim_ruby_formatter = "rubocop"
vim.g.lazyvim_picker = "snacks"
