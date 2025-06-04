local constants = require("custom.lib.constants")
local mode = require("custom.lib.mode")
local utilities = require("custom.lib.utilities")

local function lsp_attach(_, buffer_number)
    local options = { buffer = buffer_number }

    vim.keymap.set(mode.NORMAL, "K", "<CMD>lua vim.lsp.buf.hover()<CR>", options)
    vim.keymap.set(mode.NORMAL, "gtd", "<CMD>lua vim.lsp.buf.definition()<CR>", options)
    vim.keymap.set(mode.NORMAL, "gtD", "<CMD>lua vim.lsp.buf.declaration()<CR>", options)
    vim.keymap.set(mode.NORMAL, "gti", "<CMD>lua vim.lsp.buf.implementation()<CR>", options)
    vim.keymap.set(mode.NORMAL, "gto", "<CMD>lua vim.lsp.buf.type_definition()<CR>", options)
    vim.keymap.set(mode.NORMAL, "gtr", "<CMD>lua vim.lsp.buf.references()<CR>", options)
    vim.keymap.set(mode.NORMAL, "gts", "<CMD>lua vim.lsp.buf.signature_help()<CR>", options)
    vim.keymap.set(mode.NORMAL, "<F2>", "<CMD>lua vim.lsp.buf.rename()<CR>", options)
    vim.keymap.set({ mode.NORMAL, mode.VISUAL }, "<F3>", "<CMD>lua vim.lsp.buf.format({async = true})<CR>", options)
    vim.keymap.set(mode.NORMAL, "<F4>", "<CMD>lua vim.lsp.buf.code_action()<CR>", options)
end

local function config()
    local lsp = require("lsp-zero")

    vim.lsp.config("lua_ls", utilities.with_capabilities(constants.LSP_OPTIONS.lua_ls))
    vim.lsp.config("sourcery", utilities.with_capabilities(constants.LSP_OPTIONS.sourcery))

    if not utilities.exists("/etc/nixos") then
        local mason_tool_installer = require("mason-tool-installer")

        mason_tool_installer.setup({
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
                "sourcery",
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
                ["mason-lspconfig"] = false,
                ["mason-nvim-dap"] = false,
                ["mason-null-ls"] = false,
            },
            run_on_start = false,
        })
        mason_tool_installer.run_on_start()
    end

    lsp.extend_lspconfig(utilities.with_capabilities({
        lsp_attach = lsp_attach,
        sign_text = true,
    }))
    lsp.on_attach(function(_, buffer)
        lsp.default_keymaps({ buffer = buffer })
    end)
end

if utilities.exists("/etc/nixos") then
    return {
        {
            "neovim/nvim-lspconfig",
            cmd = { "LspInfo", "LspInstall", "LspStart" },
            event = { "BufReadPre", "BufNewFile" },
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
            },
            config = config,
        },
    }
else
    return {
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
                { "<leader>l", ":Mason<CR>" },
            },
        },
        {
            "neovim/nvim-lspconfig",
            event = { "BufReadPre", "BufNewFile" },
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "williamboman/mason.nvim",
                "WhoIsSethDaniel/mason-tool-installer.nvim",
            },
            config = config,
        },
    }
end
