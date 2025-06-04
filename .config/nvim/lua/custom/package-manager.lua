local constants = require("custom.lib.constants")
local mode = require("custom.lib.mode")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()

        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

local lazy = require("lazy")

lazy.setup({
    change_detection = {
        enabled = false,
    },
    checker = {
        enabled = true,
        notify = false,
    },
    git = {
        cooldown = 60,
        log = { "-3" },
        throttle = {
            duration = 1000,
            enabled = true,
            rate = 4,
        },
    },
    install = {
        colorscheme = { constants.THEME.name },
    },
    spec = {
        { import = "custom.features" },
    },
})

vim.keymap.set(mode.NORMAL, "<leader>p", lazy.home)
