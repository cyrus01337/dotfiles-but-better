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
            ["<CR>"] = "actions.select",
            ["p"] = "actions.preview",
            ["q"] = "actions.close",
            ["r"] = "actions.refresh",
            ["<BS>"] = "actions.parent",
            ["~"] = "actions.open_cwd",
            ["<C-H>"] = "actions.toggle_hidden",
        },
        use_default_keymaps = false,
        view_options = {
            is_always_hidden = is_always_hidden,
            show_hidden = true,
        },
        watch_for_changes = false,
    },
}
