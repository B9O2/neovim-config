return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          exclude = { ".DS_Store" },
          include = { ".git" },
          hidden = true,
        },
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
      "<leader><space>",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
  },
}
