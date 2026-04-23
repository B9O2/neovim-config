return {
  "rcarriga/nvim-dap-ui",
  opts = {
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.25 },
          { id = "breakpoints", size = 0.25 },
          { id = "stacks", size = 0.25 },
          { id = "watches", size = 0.25 },
        },
        position = "left",
        size = 40,
      },
      {
        elements = {
          { id = "console", size = 1.0 },
        },
        position = "bottom",
        size = 10,
      },
    },
  },
  config = function(_, opts)
    local dapui = require("dapui")
    dapui.setup(opts)
    vim.api.nvim_create_autocmd("VimResized", {
      group = vim.api.nvim_create_augroup("dapui_resize", { clear = true }),
      callback = function()
        dapui.open({ reset = true })
      end,
    })
  end,
}
