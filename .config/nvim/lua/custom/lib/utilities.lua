local Utilities = {}

---@param text string
---@param pattern string
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

function Utilities.normalise(value, maximum) return Utilities.clamp(1, value, maximum) end

return Utilities

