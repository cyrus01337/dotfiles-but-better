return {
    {
        "tpope/vim-fugitive",
        cmd = { "Git" },
        keys = {
            { "ga", "<CMD>Git<CR>", remap = true },
            { "gch", ":Git checkout " },
            { "gca", "<CMD>Git commit --amend --no-edit<CR>" },
            { "gcm", "<CMD>Git commit<CR>" },
            { "gi", "<CMD>Git init<CR>" },
            { "gism", "<CMD>Git submodule update --init --recursive<CR>" },
            { "gm", ":Git merge " },
            { "gra", ":Git remote add " },
            { "gpl", ":Git pull " },
            { "gps", ":Git push " },
            { "gsm", ":Git submodule " },
            { "gusm", "<CMD>Git submodule update --recursive --remote" },
        },
        config = true,
    },
    {
        "wintermute-cell/gitignore.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        cmd = { "Gitignore" },
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
