local mode = require("custom.lib.mode")

return {
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateUp",
            "TmuxNavigateDown",
            "TmuxNavigateLeft",
            "TmuxNavigateRight",
        },
        keys = {
            { mode.NORMAL, "<leader><Up>", "<CMD>TmuxNavigateUp<CR>" },
            { mode.NORMAL, "<leader><Down>", "<CMD>TmuxNavigateDown<CR>" },
            { mode.NORMAL, "<leader><Left>", "<CMD>TmuxNavigateLeft<CR>" },
            { mode.NORMAL, "<leader><Right>", "<CMD>TmuxNavigateRight<CR>" },
        },
    },
    {
        "nvim-telescope/telescope-fzy-native.nvim",
    },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzy-native.nvim",
        },
        keys = {
            { "<leader>ff", "<CMD>Telescope find_files<CR>" },
            { "<leader>fg", "<CMD>Telescope live_grep<CR>" },
            { "<leader>fb", "<CMD>Telescope buffers<CR>" },
            { "<leader>fh", "<CMD>Telescope help_tags<CR>" },
            { "<leader>fs", "<CMD>Telescope treesitter<CR>" },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local configuration = require("telescope.config")

            local vimgrep_arguments = { unpack(configuration.values.vimgrep_arguments) }
            local extra_arguments = { "--hidden", "--glob", "!**/.git/*" }

            for _, argument in ipairs(extra_arguments) do
                table.insert(vimgrep_arguments, argument)
            end

            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<esc>"] = actions.close,
                            ["<C-u>"] = false,
                        },
                    },
                    vimgrep_arguments = vimgrep_arguments,
                },
                extensions = {
                    fzy_native = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
                pickers = {
                    find_files = {
                        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                    },
                },
            })
            telescope.load_extension("fzy_native")
        end,
    },
}
