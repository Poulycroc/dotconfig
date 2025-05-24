return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    local map = vim.keymap.set

    conform.setup({
      -- Override only the args for stylua, removing --respect-ignores
      formatters = {
        stylua = {
          -- fully replace the default args:
          args = {
            "--search-parent-directories",
            "--stdin-filepath", "$FILENAME",
            "-",  -- read from stdin
          },
        },
      },

      -- Your filetype → formatter mapping:
      formatters_by_ft = {
        lua        = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        -- …etc…
      },

      format_on_save = {
        lsp_fallback = true,
        async        = false,
        timeout_ms   = 1000,
      },
    })

    map({ "n", "v" }, "<leader>fm", function()
      conform.format({
        lsp_fallback = true,
        async        = false,
        timeout_ms   = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
