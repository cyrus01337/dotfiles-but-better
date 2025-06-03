local complex = require("custom.features.complex.lsp")
local constants = require("custom.lib.constants")
local mode = require("custom.lib.mode")
local utilities = require("custom.lib.utilities")

local function setup_language_server(server_name)
    local lsp_configuration = require("lspconfig")

    local server_found = lsp_configuration[server_name]

    if not server_found then
        print("Cannot find LSP named", server_name)

        return
    end

    local options_found = constants.LSP_OPTIONS[server_name]

    if options_found then
        options_found = utilities.with_capabilities(options_found)
    else
        options_found = {}
    end

    server_found.setup(options_found)
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

local features = {
    complex.lspconfig,
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local treesitter_configuration = require("nvim-treesitter.configs")

            local ensure_installed = {}

            if not utilities.exists("/etc/nixos") then
                ensure_installed = {
                    -- meta

                    --- (neo)vim
                    "vim",
                    "vimdoc",
                    "regex",
                    "markdown_inline",

                    --- project management
                    "gitignore",
                    "gitcommit",
                    "markdown",

                    -- web dev

                    --- front-end
                    "html",
                    "css",
                    "javascript",
                    "typescript",
                    "astro",

                    --- back-end
                    "php",
                    "sql",

                    -- dev-ops
                    "dockerfile",

                    -- software/cli
                    "bash",
                    "python",
                    "lua",

                    -- general
                    "go",
                    "nix",

                    -- configuration formats
                    "json",
                    "jsonc",
                    "yaml",
                    "toml",

                    -- documentation
                    "markdown",
                }
            end

            treesitter_configuration.setup({
                ensure_installed = ensure_installed,
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
                modules = {},
                ignore_install = {},
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
            ignore = "^$",
            mappings = {
                extra = false,
            },
            toggler = {
                line = "cl",
            },
        },
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
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp_context = require("cmp.config.context")

            local function handle_insert(fallback)
                if cmp.visible() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
                else
                    fallback()
                end
            end

            local confirm = cmp.mapping({
                c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                s = cmp.mapping.confirm({ select = true }),
                i = handle_insert,
            })

            local mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<Tab>"] = confirm,
                ["<CR>"] = confirm,
                ["<Esc>"] = cmp.mapping.abort(),
                ["<Up>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
                ["<Down>"] = cmp.mapping.select_next_item({ behavior = "select" }),
            })

            local function entry_filter(entry)
                return entry:get_kind() ~= cmp.lsp.CompletionItemKind.Text
            end

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
                snippet = {
                    expand = function(arg)
                        vim.snippet.expand(arg.body)
                    end,
                },
                sources = cmp.config.sources({
                    {
                        name = "nvim_lsp",
                        entry_filter = entry_filter,
                    },
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
                    { name = "path", keyword_length = 3 },
                }, {
                    {
                        name = "cmdline",
                        keyword_length = 3,
                        option = {
                            ignore_cmds = { "Man", "!", "%s", "$" },
                        },
                    },
                }),
            })
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
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
                javascript = {
                    "prettierd",
                    "prettier",
                    stop_after_first = true,
                },
                lua = { "stylua" },
                nix = { "alejandra" },
                php = { "php-cs-fixer" },
                python = { "isort", "black" },
                typescript = {
                    "prettierd",
                    "prettier",
                    stop_after_first = true,
                },
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
            {
                "<C-Up>",
                "<Cmd>MultipleCursorsAddUp<CR>",
                mode = { mode.NORMAL, mode.INSERT },
            },
            {
                "<C-Down>",
                "<Cmd>MultipleCursorsAddDown<CR>",
                mode = { mode.NORMAL, mode.INSERT },
            },
            {
                "<C-d>",
                "<Cmd>MultipleCursorsAddJumpNextMatch<CR>",
                mode = { mode.NORMAL, mode.INSERT, mode.VISUAL_SELECT },
            },
        },
    },
    {
        "jmbuhr/otter.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = true,
    },
}

return features
