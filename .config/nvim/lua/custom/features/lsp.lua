local mode = require("custom.lib.mode")

local function setup_language_server(serverName)
    local lsp_configuration = require("lspconfig")
    local cmp_lsp = require("cmp_nvim_lsp")

    local server_found = lsp_configuration[serverName]

    if not server_found then
        print("Cannot find LSP named", serverName)

        return
    end

    local options = {}
    local capabilities = cmp_lsp.default_capabilities()

    if serverName == "sourcery" then
        options = {
            capabilities = capabilities,
            filetypes = { "python" },
            init_options = {
                token = "user_y_c5BVAcYOzPnfPwlzXA3KddRLTISzYRpDOE38YLLztYBefizqkRjrEqNRI",
            },
        }
    elseif serverName == "lua_ls" then
        options = {
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                },
            },
        }
    end

    server_found.setup(options)
end

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

return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local treesitter_configuration = require("nvim-treesitter.configs")

            treesitter_configuration.setup({
                auto_install = false,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
            })
        end,
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        event = { "BufReadPre", "BufNewFile" },
        lazy = true,
        config = false,
        opts = {
            handlers = {
                setup_language_server,
            },
        },
        keys = {
            { "<F2>", vim.lsp.buf.rename, mode = { mode.NORMAL, mode.INSERT } },
        },
        init = function()
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        lazy = false,
        config = true,
        opts = {
            pip = {
                upgrade_pip = true,
            },
            max_concurrent_installers = 10,
        },
        keys = {
            { "<leader>l", ":Mason<CR>" },
        },
    },
    {
        "yaegassy/nette-neon.vim",
        event = { "BufReadPre", "BufNewFile" },
    },
    {
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
    },
    {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
        dependencies = "hrsh7th/nvim-cmp",
        config = function()
            local tabnine = require("cmp_tabnine.config")

            tabnine:setup({
                ignored_file_types = {
                    TelescopePrompt = true,
                },
                max_num_results = 1,
                min_percent = 90,
                run_on_every_keystroke = false,
                snippet_placeholder = "...",
                show_prediction_strength = false,
            })
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            check_ts = true,
        },
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = true,
    },
    {
        "numToStr/Comment.nvim",
        opts = {
            mappings = {
                extra = false,
            },
            opleader = {
                line = "cl",
                block = "cb",
            },
            toggler = {
                line = "ctl",
                block = "ctb",
            },
        },
        init = function()
            vim.keymap.set({ mode.NORMAL, mode.INSERT }, "<C-_>", "<Plug>(comment_toggle_linewise_current)")
            vim.keymap.set(mode.VISUAL_SELECT, "<C-_>", "<Plug>(comment_toggle_linewise_visual)")
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-cmdline",
        },
        config = function()
            local cmp = require("cmp")
            local lsp = require("lsp-zero")
            local luasnip = require("luasnip")
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp_context = require("cmp.config.context")

            local confirm = cmp.mapping({
                s = cmp.mapping.confirm({ select = true }),
                c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),

                i = function(fallback)
                    if cmp.visible() then
                        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
                    else
                        fallback()
                    end
                end,
            })
            local mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<Tab>"] = confirm,
                ["<CR>"] = confirm,
                ["<Esc>"] = cmp.mapping.abort(),
                ["<Up>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
                ["<Down>"] = cmp.mapping.select_next_item({ behavior = "select" }),
            })

            cmp.setup({
                enabled = function()
                    if mode.is(mode.COMMAND_LINE) then
                        return true
                    end

                    return not cmp_context.in_treesitter_capture("comment")
                        and not cmp_context.in_syntax_group("Comment")
                end,
                experimental = {
                    ghost_text = true,
                },
                -- TODO: Resolve type error regarding missing fields
                formatting = {
                    format = function(entry, item)
                        lsp.cmp_format({ details = true })

                        return require("nvim-highlight-colors").format(entry, item)
                    end,
                },
                mapping = mapping,
                snippets = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                sources = cmp.config.sources({
                    {
                        name = "nvim_lsp",
                        entry_filter = function(entry)
                            return cmp.lsp.CompletionItemKind.Text ~= entry:get_kind()
                        end,
                    },
                    -- { name = "path" },
                    { name = "luasnip" },
                    { name = "lazydev" },
                    { name = "cmp_tabnine", group_index = 0, keyword_length = 3 },
                }, {
                    { name = "buffer", keyword_length = 1 },
                }),
            })
            cmp.setup.cmdline(":", {
                mapping = mapping,
                matching = { disallow_symbol_nonprefix_matching = false },
                sources = cmp.config.sources({
                    { name = "path", keyword_length = 2 },
                }, {
                    {
                        name = "cmdline",
                        keyword_length = 2,
                        option = {
                            ignore_cmds = { "Man", "!" },
                        },
                    },
                }),
            })
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },
    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local lsp = require("lsp-zero")
            local mason_lsp_configuration = require("mason-lspconfig")
            local neovim_completion_lsp = require("cmp_nvim_lsp")
            local neovim_lsp_configuration = require("lspconfig")

            local capabilities = neovim_completion_lsp.default_capabilities()

            lsp.extend_lspconfig({
                capabilities = capabilities,
                lsp_attach = lsp_attach,
                sign_text = true,
            })
            lsp.on_attach(function(_, buffer)
                lsp.default_keymaps({ buffer = buffer })
            end)

            mason_lsp_configuration.setup({
                handlers = { setup_language_server },
            })
            mason_lsp_configuration.setup_handlers({
                function(server)
                    local configuration = neovim_lsp_configuration[server]

                    configuration.setup({
                        capabilities = capabilities,
                    })
                end,
            })
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            enable_check_bracket_line = false,
        },
    },
    {
        "windwp/nvim-ts-autotag",
        config = true,
    },
    {
        "stevearc/conform.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            formatters_by_ft = {
                javascript = { "prettier" },
                lua = { "stylua" },
                php = { "php-cs-fixer" },
                python = { "isort", "black" },
                typescript = { "prettier" },
            },
            format_on_save = {
                lsp_format = "fallback",
                timeout_ms = 500,
            },
        },
    },
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        config = true,
    },
    {
        "brenton-leighton/multiple-cursors.nvim",
        version = "*",
        config = true,
        keys = {
            { "<C-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { mode.NORMAL, mode.INSERT } },
            { "<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { mode.NORMAL, mode.INSERT } },
            {
                "<C-d>",
                "<Cmd>MultipleCursorsAddJumpNextMatch<CR>",
                mode = { mode.NORMAL, mode.INSERT, mode.VISUAL_SELECT },
            },
        },
    },
}
