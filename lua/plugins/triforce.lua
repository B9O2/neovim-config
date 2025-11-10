return {
  "gisketch/triforce.nvim",
  dependencies = {
    "nvzone/volt",
  },
  config = function()
    require("triforce").setup({
      -- Optional: Add your configuration here
      keymap = {
        show_profile = "<leader>tp", -- Open profile with <leader>tp
      },
    })

    require("lualine").setup({
      sections = {
        lualine_x = {
          -- Add one or more components
          function()
            return require("triforce.lualine").level()
          end,
          function()
            return require("triforce.lualine").achievements()
          end,
          "encoding",
          "filetype",
        },
      },
    })
  end,
}
