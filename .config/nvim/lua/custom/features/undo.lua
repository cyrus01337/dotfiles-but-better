local mode = require("custom.lib.mode")

return {
    "mbbill/undotree",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
        { "<C-u>", "<CMD>UndotreeToggle<CR>", mode = { mode.NORMAL, mode.INSERT } },
    },
    init = function()
        vim.g.undotree_SetFocusWhenToggle = true
    end,
}
