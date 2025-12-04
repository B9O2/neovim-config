return {
  "zbirenbaum/copilot.lua",
  -- dependencies = {
  --   "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
  --   opts = {},
  -- },
  event = "VeryLazy",
  setup = {
    suggestion = {
      enabled = false,
    },
    -- nes = {
    --   enabled = true, -- requires copilot-lsp as a dependency
    --   auto_trigger = false,
    --   keymap = {
    --     accept_and_goto = false,
    --     accept = false,
    --     dismiss = false,
    --   },
    -- },
  },
}
