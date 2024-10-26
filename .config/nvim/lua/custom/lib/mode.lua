--- @enum Mode
local mode = {
    NORMAL = "n",
    INSERT = "i",
    VISUAL = "v",
    VISUAL_LINE = "V",
    COMMAND_LINE = "c",
    ALL = { "n", "i", "v" },
}

---@param mode_ string
---@return boolean
function mode.is(mode_)
    local current_mode_information = vim.api.nvim_get_mode()
    local current_mode = current_mode_information.mode
    local modes_match = current_mode == mode_

    -- because there's 3 several ways to enter visual mode, we special case it
    -- with the below conditions
    if mode_ == mode.VISUAL then
        return modes_match or current_mode == "V" or current_mode == "CTRL-V"
    end

    return modes_match
end

return mode
