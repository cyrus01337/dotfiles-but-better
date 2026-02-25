local PRETTIER = { "prettierd", "prettier", stop_at_first = true }

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
                javascript = PRETTIER,
                javascriptreact = PRETTIER,
                lua = { "stylua" },
                luau = { "stylua" },
                nix = { "alejandra" },
                php = { "php-cs-fixer" },
                python = { "ruff" },
                typescript = PRETTIER,
                typescriptreact = PRETTIER,
            },
            format_on_save = {
                lsp_fallback = true,
                timeout_ms = 2500,
            },
        },
    },
}
