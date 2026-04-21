return {
  {
    "neovim/nvim-lspconfig",
    keys = {
      { "gl", vim.diagnostic.open_float, desc = "Show diagnostics in float" },
      { "gi", function() vim.lsp.buf.implementation() end, desc = "Go To Implementation" },
      { "gd", function() vim.lsp.buf.definition() end, desc = "Go To Definition" },
      { "gr", function() vim.lsp.buf.references() end, desc = "Go To References" },
      { "gD", function() vim.lsp.buf.declaration() end, desc = "Go To Declaration" },
      { "gt", function() vim.lsp.buf.type_definition() end, desc = "Go To Type Definition" },
      {
        "<leader>cr",
        function()
          return ":" .. require("inc_rename").config.cmd_name .. " " .. vim.fn.expand("<cword>")
        end,
        expr = true,
        desc = "Rename (inc-rename.nvim)",
      },
    },
  },
}
