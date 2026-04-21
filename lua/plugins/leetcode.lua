return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
  dependencies = {
    -- include a picker of your choice, see picker section for more details
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    lang = "rust",
    cn = { enabled = false },

    storage = {
      home = vim.fn.expand("$HOME/leetcode"),
      cache = vim.fn.stdpath("cache") .. "/leetcode",
    },

    hooks = {
      ["enter"] = function() end,
    },
  },
}
