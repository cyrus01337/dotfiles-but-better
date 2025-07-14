local mode = require("custom.lib.mode")

return {
    "sQVe/sort.nvim",
    cmd = {
        "Sort",
    },
    keys = {
        { "so", "<CMD>Sort<CR>", mode = mode.VISUAL_SELECT },
        { "so", "<CMD>'<,'>Sort<CR>", mode = mode.VISUAL },
    },
    config = true,
}
