-- blink.cmp is a completion plugin with support for LSPs, cmdline, signature help, and snippets.
return {
  "saghen/blink.cmp",
  optional = true,
  dependencies = {
    "fang2hou/blink-copilot",
    opts = {
      max_completions = 3, -- Global default for max completions
      max_attempts = 2, -- Global default for max attempts
    },
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    sources = {
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = -50,
          async = true,
          opts = {
            -- Local options override global ones
            max_completions = 3, -- Override global max_completions

            -- Final settings:
            -- * max_completions = 3
            -- * max_attempts = 2
            -- * all other options are default
          },
        },
        path = {
          -- Path sources triggered by "/" interfere with CopilotChat commands
          enabled = function()
            return vim.bo.filetype ~= "copilot-chat"
          end,
        },
      },
    },
  },
}
