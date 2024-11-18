return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "RRethy/nvim-treesitter-endwise" },
    keys = {
      { "zf", "<Cmd>Telescope spell_suggest<CR>", desc = "Telescope: Find spell word suggestion" },
    },
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "pkl",
        "gotmpl",
        "ruby",
      })
      opts.endwise = { enable = true }
      opts.indent = { enable = true, disable = { "yaml", "ruby" } }
    end,
  },
  "ngalaiko/tree-sitter-go-template",
  {
    "mfussenegger/nvim-lint",
    dependencies = {
      "axieax/typo.nvim",
    },
    opts = {
      linters_by_ft = {
        fish = { "fish" },
        ["*"] = { "typos" },
      },
    },
  },
}
