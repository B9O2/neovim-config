return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      -- 核心配置就在这里
      -- 添加 rustfmt 作为 Rust 文件的格式化程序
      rust = { "rustfmt" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
    },
  },
}
