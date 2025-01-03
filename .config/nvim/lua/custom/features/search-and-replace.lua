local mode = require("custom.lib.mode")

---@param replace? boolean
---@param global? boolean
local function search(replace, global)
    if replace == nil then
        replace = false
    end

    if global == nil then
        global = false
    end

    return function()
        local grug_far = require("grug-far")

        local currently_selected_word = vim.fn.expand("<cword>")
        local current_buffer_filepath = vim.fn.expand("%")
        local options = {
            prefills = {
                search = currently_selected_word,
            },
            transient = true,
        }

        if replace then
            options.startCursorRow = 2
        end

        if not global then
            options.flags = current_buffer_filepath
        end

        if mode.is(mode.NORMAL) then
            grug_far.grug_far(options)
        else
            grug_far.with_visual_selection(options)
        end
    end
end

return {
    "MagicDuck/grug-far.nvim",
    event = "BufReadPre",
    keys = {
        { "<C-f>", search(), mode = mode.ALL },
        { "<C-h>", search(true), mode = mode.ALL, remap = true },
        { "<CS-f>", search(nil, true), mode = mode.ALL },
        { "<CS-h>", search(true, true), mode = mode.ALL },
    },
    opts = {
        debounceMs = 100,
        keymaps = {
            replace = { n = "<Enter>" },
            qflist = false,
            syncLocations = { n = "<C-CR>" },
            syncLine = false,
            close = { n = "<ESC>" },
            historyOpen = false,
            historyAdd = false,
            refresh = { n = "r" },
            openLocation = false,
            gotoLocation = false,
            pickHistoryEntry = false,
            abort = false,
            help = false,
            toggleShowCommand = false,
            swapEngine = false,
        },
    },
}
