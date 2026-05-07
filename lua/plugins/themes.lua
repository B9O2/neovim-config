-- Dynamic Theme
local theme_name = "rose_pine"
local variant_name = "moon"

local themes = {
  rose_pine = { "rose-pine/neovim", name = "rose-pine", variant_format = "rose-pine-%s" },
}

local theme = themes[theme_name]
if theme then
  theme.lazy = false
  theme.priority = 1000

  local cmd = nil
  if theme.variant_format then
    cmd = "colorscheme " .. string.format(theme.variant_format, variant_name)
  else
    cmd = "colorscheme " .. theme.name
  end

  theme.config = function()
    vim.cmd(cmd)
  end

  return theme
end

return {}
