return {
    "rmagatti/auto-session",
    lazy = false,
    init = function()
        vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end,
    opts = {
        auto_session_allowed_dirs = {
            "/workspace/",
            "/workspace/.config/{fish,nvim}/",
            "/workspace/{bin,Playground}/",
            "/workspace/Projects/*/*/",
        },
        cwd_change_handling = {
            restore_upcoming_session = true,
        },
    },
}
