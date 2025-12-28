return {
    {
        "cappyzawa/trim.nvim",
        event = "BufWritePre",
        opts = {
            highlight = false,
            trim_last_line = false,
        },
    },
    {
        "andrewferrier/wrapping.nvim",
        commands = { "ToggleWrapMode" },
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            create_keymaps = false,
        },
    },
    {
        "stevearc/conform.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            formatters_by_ft = {
                javascript = { "prettierd" },
                javascriptreact = { "prettierd" },
                lua = { "stylua" },
                nix = { "alejandra" },
                php = { "php-cs-fixer" },
                python = { "ruff" },
                typescript = { "prettierd" },
                typescriptreact = { "prettierd" },
            },
            format_on_save = {
                lsp_fallback = true,
                timeout_ms = 2500,
            },
        },
    },
}
