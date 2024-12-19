return {
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "pkl",
        "gotmpl",
      })
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

  -- {
  --   "williamboman/mason.nvim",
  --   opts = {
  --     ensure_installed = {
  --       -- "stylua",
  --       -- "shellcheck",
  --       -- "shfmt",
  --       -- "flake8",
  --     },
  --   },
  -- },
  -- {
  --   "wojciech-kulik/xcodebuild.nvim",
  --   dependencies = {
  --     "nvim-telescope/telescope.nvim",
  --     "MunifTanjim/nui.nvim",
  --   },
  -- },
  -- "mfussenegger/nvim-lint",
  -- {
  --   "stevearc/conform.nvim",
  --   opts = {
  --     formatters_by_ft = {
  --       swift = { "swiftformat" },
  --     },
  --   },
  -- },
}
