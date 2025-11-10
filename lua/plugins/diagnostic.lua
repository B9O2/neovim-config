return {
  {
    "neovim/nvim-lspconfig", -- 依赖 LSP
    config = {
      vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostics in float" }),
    },
    -- config = function()
    --   -- 绑定 gl 打开浮动诊断窗口
    --   vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostics in float" })
    -- end,
  },
}
