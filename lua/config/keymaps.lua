-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Which-key groups
local wk = require("which-key")
wk.add({
  { "<leader>m", group = "marks" },
})

vim.keymap.set("n", "d", '"_d')
vim.keymap.set("n", "D", '"_D')
vim.keymap.set("v", "d", '"_d')

vim.keymap.set("n", "c", '"_c')
vim.keymap.set("n", "C", '"_C')
vim.keymap.set("v", "c", '"_c')

vim.keymap.set("n", "q", "<Nop>", { desc = "Disable macro recording" })

vim.keymap.set("n", "<leader>\\", "<cmd>vsplit<cr>", { desc = "Split window right" })

-- Marks
vim.keymap.set("n", "<leader>md", function()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local marks = vim.fn.getmarklist("%")
  local marks_to_delete = {}
  for _, mark in ipairs(marks) do
    if mark.pos[2] == line and mark.mark:match("^'[a-z]$") then
      table.insert(marks_to_delete, mark.mark:sub(2))
    end
  end
  if #marks_to_delete > 0 then
    vim.cmd("delmarks " .. table.concat(marks_to_delete, ""))
    vim.notify("Deleted marks: " .. table.concat(marks_to_delete, ", "))
  else
    vim.notify("No marks on current line")
  end
end, { desc = "Delete marks on current line" })

vim.keymap.set("n", "<leader>mo", function()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local marks = vim.fn.getmarklist("%")
  local marks_to_delete = {}
  for _, mark in ipairs(marks) do
    if mark.pos[2] ~= line and mark.mark:match("^'[a-z]$") then
      table.insert(marks_to_delete, mark.mark:sub(2))
    end
  end
  if #marks_to_delete > 0 then
    vim.cmd("delmarks " .. table.concat(marks_to_delete, ""))
    vim.notify("Deleted " .. #marks_to_delete .. " marks (kept current line)")
  else
    vim.notify("No other marks to delete")
  end
end, { desc = "Delete all marks except current line" })

-- Delete the <C-f> keymap for file search functionality
vim.keymap.del("n", "<C-f>")
