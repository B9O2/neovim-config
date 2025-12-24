return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {},
      },
    },
    dashboard = {
      enabled = false,
    },
    scroll = {
      enabled = false,
    },
  },
  keys = {
    {
      "<leader><leader>",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
  },
}
