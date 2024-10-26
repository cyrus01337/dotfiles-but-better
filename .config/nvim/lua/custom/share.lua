local cached_root_credential = ""

local function set_shared_permissions()
    local current_buffer_filepath = vim.fn.expand("%")
    local current_buffer_absolute_directory = vim.fn.expand("%:p")
    local in_neovim_configuration_directory = current_buffer_absolute_directory:match("/nvim/lua/custom/(.+)")
    local user = vim.fn.expand("$USER")

    if not in_neovim_configuration_directory then
        return
    end

    if not cached_root_credential or #cached_root_credential == 0 then
        local prompt = string.format("[sudo] password for %s: ", user)
        cached_root_credential = vim.fn.inputsecret(prompt)
        local cancelled = not cached_root_credential or #cached_root_credential == 0

        if cancelled then
            return
        end
    end

    local commands = {
        string.format("sudo -p '' -S chmod 776 %s", current_buffer_filepath),
        string.format("sudo -p '' -S chgrp shared %s", current_buffer_filepath),
    }

    for _, command in ipairs(commands) do
        vim.fn.system(command, cached_root_credential)
    end
end

vim.api.nvim_create_autocmd({ "BufWritePost", "FileWritePost" }, {
    group = vim.api.nvim_create_augroup("SetSharedPermissions", {}),
    pattern = "*",
    callback = set_shared_permissions,
})

