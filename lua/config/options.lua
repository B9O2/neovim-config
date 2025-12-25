-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.opt.colorcolumn = "80"
vim.opt.number = true
vim.opt.relativenumber = true

vim.g.lazyvim_picker = "snacks"
-- vim.g.lazyvim_picker = "telescope"

vim.g.ai_cmp = false

-- Neovide settings
if vim.g.neovide then
  vim.g.neovide_input_macos_option_key_is_meta = "only_left"
end
