return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        -- zls = {
        --   filetypes = { "zig", "zon" },
        --   settings = {
        --     zls = {
        --       enable_snippets = true,
        --     },
        --   },
        -- },
        nil_ls = {
          mason = false,
          formatting = {
            command = { "alejandra" },
          },
        },
        sourcekit = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim", "lovr" },
              },
            },
          },
        },
      },
    },
    -- config = function()
    --   local lspconfig = require("lspconfig")
    --   lspconfig.sourcekit.setup({})
    -- end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "typos",
      },
    },
  },
}
