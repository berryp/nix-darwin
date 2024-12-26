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
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        sections = {
          { section = "header" },
          { section = "keys", gap = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = { 2, 2 } },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
          { section = "startup" },
        },
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
