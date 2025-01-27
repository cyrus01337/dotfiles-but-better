return {
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
