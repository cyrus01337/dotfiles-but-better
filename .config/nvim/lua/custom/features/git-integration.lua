return {
    {
        "tpope/vim-fugitive",
        keys = {
            { "ga", "<CMD>Git<CR>", remap = true },
            { "gch", ":Git checkout " },
            { "gco", "<CMD>Git commit<CR>" },
            { "gi", "<CMD>Git init<CR>" },
            { "gism", "<CMD>Git submodule update --init --recursive<CR>" },
            { "gm", ":Git merge " },
            { "gra", ":Git remote add " },
            { "gpl", ":Git pull " },
            { "gps", ":Git push " },
            { "gsm", ":Git submodule " },
            { "gusm", "<CMD>Git submodule update --recursive --remote" },
        },
    },
    {
        "wintermute-cell/gitignore.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        keys = {
            { "<leader>ggi", "<CMD>Gitignore<CR>" },
        },
        config = true,
    },
    {
        "lewis6991/gitsigns.nvim",
        config = true,
    },
    {
        "akinsho/git-conflict.nvim",
        version = "*",
        config = true,
    },
}
