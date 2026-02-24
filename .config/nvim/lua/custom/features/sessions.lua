return {
    "folke/persistence.nvim",
    event = "BufReadPre",
    init = function()
        local persistence = require("persistence")

        vim.opt.sessionoptions = "buffers,folds,localoptions,tabpages,terminal,winpos,winsize"

        persistence.load()
    end,
    opts = {
        need = 0,
        options = { "globals" },
        pre_save = function()
            vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
        end,
    },
}
