local HIDDEN_OBJECT_PATHS = {
    "^.zcompdump.*",
    "^.Trash-.*",
    "^.git$",
}

local function is_always_hidden(name, _)
    if name == ".." then
        return true
    end

    for _, path in ipairs(HIDDEN_OBJECT_PATHS) do
        if name:match(path) then
            return true
        end
    end

    return false
end

return {
    "stevearc/oil.nvim",
    opts = {
        default_file_explorer = true,
        delete_to_trash = true,
        keymaps = {
            -- ["g?"] = "actions.show_help",
            ["<CR>"] = "actions.select",
            -- ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
            -- ["<C-h>"] = {
            --     "actions.select",
            --     opts = { horizontal = true },
            --     desc = "Open the entry in a horizontal split",
            -- },
            -- ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
            -- ["<C-p>"] = "actions.preview",
            ["q"] = "actions.close",
            -- ["<C-l>"] = "actions.refresh",
            ["<BS>"] = "actions.parent",
            -- ["_"] = "actions.open_cwd",
            -- ["`"] = "actions.cd",
            -- ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
            -- ["gs"] = "actions.change_sort",
            -- ["gx"] = "actions.open_external",
            ["<C-H>"] = "actions.toggle_hidden",
            -- ["g\\"] = "actions.toggle_trash",
        },
        use_default_keymaps = false,
        view_options = {
            is_always_hidden = is_always_hidden,
            show_hidden = true,
        },
        watch_for_changes = false,
    },
}
