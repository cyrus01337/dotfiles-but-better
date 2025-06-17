local function auto_create() end

local function oil()
    require("oil")
end

return {
    "rmagatti/auto-session",
    lazy = false,
    init = function()
        vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end,
    opts = {
        args_allow_files_auto_save = true,
        auto_create = auto_create,
        git_use_branch_name = true,
        git_auto_restore_on_branch_change = true,
        no_restore_cmds = { oil },
        session_lens = {
            load_on_setup = false,
        },
    },
}
