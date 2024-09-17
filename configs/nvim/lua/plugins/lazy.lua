return {
    {
        "folke/trouble.nvim",
        -- opts will be merged with the parent spec
        opts = { use_diagnostic_signs = true },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            -- add tsx and treesitter
            vim.list_extend(opts.ensure_installed, {
                -- "tsx",
                -- "typescript",
            })
        end,
    },

    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                -- "stylua",
                -- "shellcheck",
                -- "shfmt",
                -- "flake8",
            },
        },
    },
}
