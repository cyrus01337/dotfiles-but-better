local constants = require("custom.lib.constants")

local function track_most_recent_buffer() end

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

local function theyre_all_oil(buffers)
    for _, buffer in ipairs(buffers) do
        local name = vim.api.nvim_buf_get_name(buffer)

        if not name:match("^oil://") then
            return false
        end
    end

    return true
end

local function default_to_file_manager()
    local buffers = get_listed_buffers()

    print("Are they all Oil?", theyre_all_oil(buffers))
    print("Buffer count:", #buffers)
    print("Is oil starting?", #buffers == 1 and not theyre_all_oil(buffers))

    if #buffers == 1 and not theyre_all_oil(buffers) then
        vim.cmd("Oil")
    end
end

vim.api.nvim_create_autocmd("BufLeave", {
    group = vim.api.nvim_create_augroup("DefaultToFileManager", {}),
    callback = default_to_file_manager,
})
