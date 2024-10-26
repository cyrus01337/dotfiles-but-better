local constants = require("custom.lib.constants")

local function get_listed_buffers()
    local buffers = vim.api.nvim_list_bufs()

    local function predicate(buffer)
        local name = vim.api.nvim_buf_get_name(buffer)

        return name ~= constants.EMPTY
            and vim.api.nvim_buf_is_loaded(buffer)
            and vim.api.nvim_get_option_value("buflisted", { buf = buffer })
    end

    return vim.tbl_filter(predicate, buffers)
end

local function is_oil_buffer(buffer)
    local name = vim.api.nvim_buf_get_name(buffer)

    return name:match("^oil://")
end

local function default_to_file_manager()
    local most_recent_buffer = vim.api.nvim_get_current_buf()
    local most_recent_buffer_name = vim.api.nvim_buf_get_name(most_recent_buffer)
    local buffers = get_listed_buffers()

    print("Buffer count:", #buffers)
    print("Most recent buffer", most_recent_buffer_name)

    if #buffers == 1 and not is_oil_buffer(most_recent_buffer) then
        vim.cmd("Oil")
    end
end

vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("DefaultToFileManager", {}),
    callback = default_to_file_manager,
})
