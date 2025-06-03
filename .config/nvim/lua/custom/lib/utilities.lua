-- TODO: Document types
local os = require("os")

local Utilities = {}
local cached_default_capabilities

---@param text string
---@param pattern string
---
---@return function
function Utilities.gfind(text, pattern)
    local iterations = 0

    return function()
        iterations = iterations + 1

        return string.find(text, pattern, iterations)
    end
end

function Utilities.clamp(minimum, value, maximum)
    if value < minimum then
        return minimum
    elseif value > maximum then
        return maximum
    end

    return value
end

function Utilities.normalise(value, maximum)
    return Utilities.clamp(1, value, maximum)
end

function Utilities.exists(file)
    local success, error, code = os.rename(file, file)

    if not success and code == 13 then
        return true, nil
    end

    return success, error
end

function Utilities.cloneTable(container)
    local copy = {}

    for key, value in pairs(container) do
        if type(value) == "table" then
            -- must convert to table to label value as an iterable
            local value = value

            value = Utilities.cloneTable(value)
        end

        copy[key] = value
    end

    return copy
end

function Utilities.with_capabilities(object)
    if not cached_default_capabilities then
        local cmp_lsp = require("cmp_nvim_lsp")

        cached_default_capabilities = cmp_lsp.default_capabilities()
    end

    local cloned = Utilities.cloneTable(object)
    cloned.capabilities = cached_default_capabilities

    return cloned
end

return Utilities
