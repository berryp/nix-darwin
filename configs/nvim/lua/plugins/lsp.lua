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
        buf_ls = {},
        clangd = {
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        },
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
        "bacon-ls",
      },
    },
  },
}
