return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Run on every file
        ["*"] = { "trim_whitespace", "trim_newlines" },
        nix = { "alejandra" },
      },
      -- format_on_save = {
      --   timeout_ms = 500,
      --   lsp_fallback = true,
      -- },
    },
  },
}
