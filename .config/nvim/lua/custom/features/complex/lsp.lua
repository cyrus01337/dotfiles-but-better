local constants = require("custom.lib.constants")
local utilities = require("custom.lib.utilities")

local dependencies
local complex_features

if utilities.exists("/etc/nixos") then
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "williamboman/mason-lspconfig.nvim",
    }
else
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    }
end

local function config()
    local lsp = require("lsp-zero")
    local neovim_completion_lsp = require("cmp_nvim_lsp")
    local neovim_lsp_configuration = require("lspconfig")

    if not utilities.exists("/etc/nixos") then
        local mason_lsp_configuration = require("mason-lspconfig")

        mason_lsp_configuration.setup({
            automatic_installation = true,
            ensure_installed = {
                -- web dev

                --- front-end
                "html",
                "cssls",
                "tailwindcss",
                "eslint",
                "ts_ls",
                "astro",
                "mdx_analyzer",

                --- back-end
                "sqlls",

                -- dev-ops
                "dockerls",
                "docker_compose_language_service",

                -- software/cli
                "bashls",
                "pyright",
                "sourcery",
                "lua_ls",

                -- general
                "gopls",

                -- configuration formats
                "jsonls",
                "taplo",
                "yamlls",

                -- documentation
                "markdown_oxide",
            },
        })
    end

    vim.lsp.config("lua_ls", utilities.with_capabilities(constants.LSP_OPTIONS.lua_ls))
    vim.lsp.config("sourcery", utilities.with_capabilities(constants.LSP_OPTIONS.sourcery))

    lsp.extend_lspconfig(utilities.with_capabilities({
        lsp_attach = lsp_attach,
        sign_text = true,
    }))
    lsp.on_attach(function(_, buffer)
        lsp.default_keymaps({ buffer = buffer })
    end)
end

if not utilities.exists("/etc/nixos") then
    complex_features = {
        {
            "williamboman/mason.nvim",
            build = ":MasonUpdate",
            lazy = false,
            config = true,
            opts = {
                pip = {
                    upgrade_pip = true,
                },
                max_concurrent_installers = 8,
            },
            keys = {
                { "<leader>l", ":Mason<CR>" },
            },
        },
        {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            build = ":MasonToolsInstall",
            options = {
                ensure_installed = {
                    "prettierd",
                    "black",
                    "isort",
                    "alejandra",
                },
            },
        },
    }
else
    complex_features = {}
end

return {
    lspconfig = {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = dependencies,
        config = config,
    },

    unpack(complex_features),
}
