local os = require("os")

local home_directory = os.getenv("XDG_CONFIG_HOME")
local NEOVIM_CONFIGURATION_DIRECTORY = home_directory and (home_directory .. "/nvim") or vim.fn.expand("~/.config/nvim")

---@param name "web-development"
---
---@return string, string
local function ignore_from_nonglobal_rgignores(name)
    return "--ignore-file", NEOVIM_CONFIGURATION_DIRECTORY .. "/ripgrep/" .. name .. ".rgignore"
end

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
            { "<leader><Up>", "<CMD>TmuxNavigateUp<CR>" },
            { "<leader><Down>", "<CMD>TmuxNavigateDown<CR>" },
            { "<leader><Left>", "<CMD>TmuxNavigateLeft<CR>" },
            { "<leader><Right>", "<CMD>TmuxNavigateRight<CR>" },
        },
        config = true,
    },
    {
        "nvim-telescope/telescope-fzy-native.nvim",
        config = true,
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
                        find_command = {
                            "rg",
                            "--files",
                            "--hidden",
                            "--ignore",
                            ignore_from_nonglobal_rgignores("web-development"),
                        },
                    },
                },
            })
            telescope.load_extension("fzy_native")
        end,
    },
}
