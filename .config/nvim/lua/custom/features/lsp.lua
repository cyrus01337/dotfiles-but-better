local lsp = require("custom.features.complex.lsp")
local mode = require("custom.lib.mode")
local utilities = require("custom.lib.utilities")

vim.diagnostic.config({ virtual_text = true })

return utilities.concatenate_tables(lsp, {
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

                    -- game dev
                    "luau",
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
        "yaegassy/nette-neon.vim",
        event = { "BufReadPre", "BufNewFile" },
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
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
            local ts_context_commentstring = require("ts_context_commentstring")

            ts_context_commentstring.setup({
                enable_autocmd = false,
            })
        end,
    },
    {
        "numToStr/Comment.nvim",
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            local comment = require("Comment")

            comment.setup({
                extra = {
                    above = "<Nop>",
                    below = "<Nop>",
                    eol = "<Nop>",
                },
                ignore = "^ *$",
                mappings = {
                    basic = true,
                    extra = false,
                },
                opleader = {
                    line = "<Nop>",
                    block = "<Nop>",
                },
                padding = true,
                post_hook = function(...) end,
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
                sticky = true,
                toggler = {
                    line = "cl",
                    block = "cb",
                },
            })
        end,
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
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp_context = require("cmp.config.context")
            local cmp_nvim_lsp = require("cmp_nvim_lsp")

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

            vim.lsp.config("*", {
                capabilities = cmp_nvim_lsp.default_capabilities(),
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
                -- matching = { disallow_symbol_nonprefix_matching = false },
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
        "OXY2DEV/markview.nvim",
        lazy = false,
        priority = 49,
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
})
