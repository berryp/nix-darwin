return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        nil_ls = {
          mason = false,
          formatting = {
            command = { "alejandra" },
          },
        },
        sourcekit = {},
      },
    },
    -- config = function()
    --   local lspconfig = require("lspconfig")
    --   lspconfig.sourcekit.setup({})
    -- end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },

    opts = function(_, opts)
      ensure_installed = {
        "typos",
      }
    end,
  },
}
