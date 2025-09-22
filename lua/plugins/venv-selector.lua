return {
  {
    "linux-cultist/venv-selector.nvim",
    branch = "main", -- 或者 “regexp” 分支，如果你想用最新功能
    dependencies = {
      "neovim/nvim-lspconfig",
      { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
      -- 如果你也用 fzf-lua 或其他 picker，可以加它们
    },
    ft = "python", -- 只在 python 文件时加载
    cmd = "VenvSelect", -- 提供这个命令
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select Python VirtualEnv", mode = { "n" }, ft = "python" },
    },
    opts = {
      options = {
        notify_user_on_venv_activation = false,
        -- 你可以在这里加你想要的回调，比如激活虚拟环境后重启 pyright
        on_venv_activate_callback = function()
          -- 重启 pyright，或者通知 lsp 重载
          local lspconfig = require("lspconfig")
          for _, client in pairs(vim.lsp.get_active_clients()) do
            if client.name == "pyright" then
              client.stop()
            end
          end
          -- 然后重新启动缓存里的 server，如果 LazyVim 用的是 lspconfig + mason-multi 或类似机制，这里不一定要写很多
          vim.cmd("edit") -- 或者你喜欢的方式刷新 buffer
        end,
      },
      -- 如果你的虚拟环境在非标准位置，可以定义额外的 search
      search = {
        my_project_venvs = {
          command = "fd /bin/python$ .venv", -- 举例，只搜索当前目录下 .venv/bin/python
        },
      },
    },
  },
}
