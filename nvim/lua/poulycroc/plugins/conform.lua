return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "lua_ls" },
      javascript = { { "prettierd", "prettier" }, { "eslint_d", "eslint" } },
      typescript = { { "prettierd", "prettier" }, { "eslint_d", "eslint" } },
    },
    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
}
