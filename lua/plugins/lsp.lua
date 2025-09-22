return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pyright = {
        before_init = function(_, config)
          local venv_path = require("venv-selector").python()
          if venv_path and venv_path ~= "" then
            config.settings = config.settings or {}
            config.settings.python = config.settings.python or {}
            config.settings.python.pythonPath = venv_path
          end
        end,
      },
      ruff_lsp = {
        cmd_env = { RUFF_TRACE = "messages" },
        init_options = {
          settings = {
            logLevel = "error",
          },
        },
        keys = {
          {
            "<leader>co",
            LazyVim.lsp.action["source.organizeImports"],
            desc = "Organize Imports",
          },
        },
      },
    },
    setup = {
      ["ruff_lsp"] = function()
        LazyVim.lsp.on_attach(function(client, _)
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end, "ruff_lsp")
      end,
    },
  },
  keys = {
    {
      "gi",
      function()
        vim.lsp.buf.implementation()
      end,
      desc = "Go To Implementation",
    },
    {
      "gd",
      function()
        vim.lsp.buf.definition()
      end,
      desc = "Go To Definition",
    },
    {
      "gr",
      function()
        vim.lsp.buf.references()
      end,
      desc = "Go To References",
    },
    {
      "gD",
      function()
        vim.lsp.buf.declaration()
      end,
      desc = "Go To Declaration",
    },
    {
      "gt",
      function()
        vim.lsp.buf.type_definition()
      end,
      desc = "Go To Type Definition",
    },
  },
}
