return {
    {
        "cappyzawa/trim.nvim",
        event = "BufWritePre",
        opts = {
            highlight = false,
            trim_last_line = false,
        },
    },
    {
        "andrewferrier/wrapping.nvim",
        commands = { "ToggleWrapMode" },
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            create_keymaps = false,
        },
    },
}
