local constants = require("custom.lib.constants")
local mode = require("custom.lib.mode")

return {
    {
        constants.THEME.package,
        name = constants.THEME.name,
        priority = 1000,
        config = function()
            local command = string.format("colorscheme %s", constants.THEME.name)

            vim.cmd(command)
        end,
    },
    {
        "m-demare/hlargs.nvim",
        config = true,
    },
    {
        "romgrk/barbar.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "lewis6991/gitsigns.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        init = function()
            vim.g.barbar_auto_setup = false
        end,
        opts = {
            auto_hide = 1,
            buffer_number = true,
            clickable = false,
            exclude_name = { "nvim" },
            insert_at_end = true,
            no_name_title = "Untitled",
            preset = "slanted",
            separator_at_end = true,
        },
    },
    {
        "sontungexpt/sttusline",
        branch = "table_version",
        event = "BufEnter",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        init = function()
            vim.opt.laststatus = 3
        end,
        opts = {
            components = {
                "mode",
                "filename",
                "git-branch",
                "git-diff",
                "%=",
                "diagnostics",
                "indent",
                "encoding",
                "pos-cursor",
                "datetime",
            },
            disabled = {
                filetypes = {
                    "telescope",
                    "No File",
                },
                buftypes = {
                    "terminal",
                },
            },
        },
    },
    {
        "folke/todo-comments.nvim",
        event = "BufEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true,
        keys = {
            { "<leader>ft", "<CMD>TodoTelescope<CR>", mode = mode.NORMAL },
            { "<C-t>", "<CMD>TodoTelescope<CR>", mode = { mode.NORMAL, mode.INSERT } },
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "BufEnter",
        config = true,
    },
    -- {
    --     "tris203/precognition.nvim",
    --     opts = {
    --         disabled_fts = { "netrw" },
    --     },
    -- },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = true,
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    {
        "junegunn/limelight.vim",
        event = "InsertEnter",
        config = function()
            local group = vim.api.nvim_create_augroup("Hyperfocus", {})

            vim.api.nvim_create_autocmd({ "InsertEnter" }, {
                group = group,
                pattern = "*",
                callback = function()
                    vim.cmd("Limelight")
                end,
            })

            vim.api.nvim_create_autocmd({ "InsertLeave" }, {
                group = group,
                pattern = "*",
                callback = function()
                    vim.cmd("Limelight!")
                end,
            })
        end,
    },
    {
        "brenoprata10/nvim-highlight-colors",
        opts = {
            enable_tailwind = true,
        },
    },
}
