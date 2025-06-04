return {
    "rmagatti/auto-session",
    lazy = false,
    init = function()
        vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end,
    opts = {
        auto_restore_last_session = true,
        cwd_change_handling = true,
    },
}
