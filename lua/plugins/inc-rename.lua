return {
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {},
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            {
              "<leader>cr",
              "<cmd>IncRename<CR>",
              desc = "Rename (IncRename)",
              has = "rename",
            },
          },
        },
      },
    },
  },
}
