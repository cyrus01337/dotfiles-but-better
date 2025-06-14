local constants = require("custom.lib.constants")
local utilities = require("custom.lib.utilities")

local LAZYDEV = {
    "folke/lazydev.nvim",
    event = { "BufReadPre", "BufNewFile" },
    ft = "lua",
    opts = {
        library = {
            "~/.config/nvim/lua/lib",
            "lazy.nvim",
            "LazyVim",
        },
    },
}

local function config()
    local lspconfig = require("lspconfig")

    for _, name in ipairs(constants.NO_CONFIGURATION_LSPS) do
        local language_server = lspconfig[name]

        language_server.setup(utilities.extend_lsp_options({}))
    end

    for name, options in pairs(constants.LSP_OPTIONS) do
        local language_server = lspconfig[name]

        language_server.setup(utilities.extend_lsp_options(options))
    end
end

if utilities.exists("/etc/nixos") then
    return {
        {
            "neovim/nvim-lspconfig",
            event = { "BufReadPre", "BufNewFile" },
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "folke/lazydev.nvim",
            },
            config = config,
        },
        LAZYDEV,
    }
else
    return {
        {
            "neovim/nvim-lspconfig",
            event = { "BufReadPre", "BufNewFile" },
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "folke/lazydev.nvim",
                "williamboman/mason.nvim",
                "WhoIsSethDaniel/mason-tool-installer.nvim",
            },
            config = config,
        },
        LAZYDEV,
        {
            "williamboman/mason.nvim",
            build = ":MasonUpdate",
            lazy = false,
            opts = {
                pip = {
                    upgrade_pip = true,
                },
                max_concurrent_installers = 8,
            },
            keys = {
                { "<leader>m", "<CMD>Mason<CR>" },
            },
        },
        {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            build = ":MasonToolsInstall",
            lazy = false,
            opts = {
                auto_update = true,
                ensure_installed = {
                    "ast-grep",
                    "astro-language-server",
                    "bash-language-server",
                    "beautysh",
                    "black",
                    "css-lsp",
                    "css-variables-language-server",
                    "eslint-lsp",
                    "gopls",
                    "html-lsp",
                    "isort",
                    "json-lsp",
                    "lua-language-server",
                    "prettierd",
                    "pyright",
                    "python-lsp-server",
                    "rust-analyzer",
                    "stylua",
                    "tailwindcss-language-server",
                    "taplo",
                    "ts-standard",
                    "typescript-language-server",
                    "vim-language-server",
                    "vue-language-server",
                    "yaml-language-server",
                },
                integrations = {
                    ["mason-lspconfig"] = true,
                    ["mason-nvim-dap"] = false,
                    ["mason-null-ls"] = false,
                },
                run_on_start = false,
            },
        },
    }
end
