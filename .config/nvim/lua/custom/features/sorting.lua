local mode = require("custom.lib.mode")

return {
    "sQVe/sort.nvim",
    cmd = {
        "Sort",
    },
    keys = {
        { "s", "<CMD>Sort<CR>", mode = mode.VISUAL_SELECT },
    },
    config = true,
}
