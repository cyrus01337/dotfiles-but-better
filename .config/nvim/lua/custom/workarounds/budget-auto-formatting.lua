-- TODO: Setup auto-formatting manually using auto-commands, with support for
-- checks that run based on existing options

---@param executable string
---@param check function | nil
local function create_formatter_reference(executable, check)
    return {
        executable = executable,
        check = check,
    }
end

local FORMATTERS = {}

-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--     callback = function(event)
--         print(string.format("event fired: %s", vim.inspect(event)))
--     end,
-- })
