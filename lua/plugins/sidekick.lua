local haunt_sk = require("haunt.sidekick")
return {
  "folke/sidekick.nvim",
  cmd = "Sidekick",
  ---@class sidekick.Config
  opts = {
    copilot = {
      status = {
        enabled = false,
      },
    },
    nes = {
      enabled = false,
    },
    mux = {
      enabled = false,
      create = "window",
    },
    cli = {
      win = {
        layout = "float",
        float = {
          width = 0.6,
          height = 0.8,
          border = "rounded",
        },
      },
      prompts = {
        haunt_all = function()
          return haunt_sk.get_locations()
        end,
        haunt_buffer = function()
          return haunt_sk.get_locations({ current_buffer = true })
        end,
      },
    },
  },
  keys = {
    {
      "<leader>ag",
      function()
        require("sidekick.cli").toggle({ name = "gemini", focus = true })
      end,
      desc = "Sidekick Toggle Gemini",
    },
  },
}
