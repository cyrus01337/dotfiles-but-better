local function auto_source_configuration_file()
    local current_buffer = vim.api.nvim_get_current_buf()
    local current_buffer_absolute_filepath = vim.api.nvim_buf_get_name(current_buffer)
    local current_buffer_filename = vim.fn.expand("%")
    local is_configuration_file = current_buffer_absolute_filepath:match("/nvim/lua/.+")
    local is_plugin_file = current_buffer_absolute_filepath:match("/nvim/lua/.+/plugins")
    local is_archived = current_buffer_absolute_filepath:match("/nvim/lua/archive/.+")

    if not is_configuration_file or is_plugin_file or is_archived then
        return
    end

    local command = string.format("source %s", current_buffer_absolute_filepath)
    local output = string.format("Auto-sourced %s", current_buffer_filename)

    vim.cmd(command)
    print(output)
end

vim.api.nvim_create_autocmd({ "BufWritePost", "FileWritePost" }, {
    group = vim.api.nvim_create_augroup("AutoSourceConfigurationFile", {}),
    pattern = "*.lua",
    callback = auto_source_configuration_file,
})
