return {
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
    },
  },
}
