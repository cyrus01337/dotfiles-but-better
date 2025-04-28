local mode = {
    NORMAL = "n",
    INSERT = "i",
    VISUAL = "v",
    VISUAL_LINE = "V",
    COMMAND_LINE = "c",
    ALL = { "n", "i", "v" },
}

---@alias Mode
---| "n"
---| "i"
---| "v"
---| "V"
---| "c"
---
---@param ... string
---
---@return Mode | Mode[]
function mode.UNKNOWN(...)
    ---@type Mode[]
    local modes = { ... }

    if #modes == 1 then
        return modes[1]
    end

    return modes
end

---@param ... Mode | Mode[]
---
---@return boolean
function mode.is(...)
    local current_mode_information = vim.api.nvim_get_mode()
    local current_mode = current_mode_information.mode
    local modes = { ... }
    local modes_match = false

    for _, object in ipairs(modes) do
        if type(object) == "string" then
            if #object > 0 then
                modes_match = object == current_mode
            end
        elseif type(object) == "table" then
            if #object == 1 then
                modes_match = object[1] == current_mode
            elseif #object > 1 then
                modes_match = mode.is(object)
            end
        end

        if modes_match then
            break
        end
    end

    return modes_match
end

return mode
