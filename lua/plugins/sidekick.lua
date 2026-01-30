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
        layout = "right",
        split = {
          height = 15,
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
