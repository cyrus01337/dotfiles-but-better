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

function Utilities.clone_table(container)
    local copy = {}

    for key, value in pairs(container) do
        if type(value) == "table" then
            -- must convert to table to label value as an iterable
            local value = value

            value = Utilities.clone_table(value)
        end

        copy[key] = value
    end

    return copy
end

local function on_attach(client, _)
    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { 0 })
    end
end

function Utilities.extend_lsp_options(object)
    if not cached_default_capabilities then
        local cmp_lsp = require("cmp_nvim_lsp")

        cached_default_capabilities = cmp_lsp.default_capabilities()
    end

    local cloned = Utilities.clone_table(object)
    cloned.capabilities = cached_default_capabilities
    cloned.on_attach = on_attach

    return cloned
end

-- https://stackoverflow.com/a/41943392
local function pretty_format(object, indentation)
    if not indentation then
        indentation = 0
    end
    local toprint = string.rep(" ", indentation) .. "{\r\n"
    indentation = indentation + 2
    for k, v in pairs(object) do
        toprint = toprint .. string.rep(" ", indentation)
        if type(k) == "number" then
            toprint = toprint .. "[" .. k .. "] = "
        elseif type(k) == "string" then
            toprint = toprint .. k .. "= "
        end
        if type(v) == "number" then
            toprint = toprint .. v .. ",\r\n"
        elseif type(v) == "string" then
            toprint = toprint .. "\"" .. v .. "\",\r\n"
        elseif type(v) == "table" then
            toprint = toprint .. pretty_format(v, indentation + 2) .. ",\r\n"
        else
            toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
        end
    end
    toprint = toprint .. string.rep(" ", indentation - 2) .. "}"
    return toprint
end

function Utilities.pretty_print(...)
    for _, object in ipairs({ ... }) do
        print(pretty_format(object, 4))
    end
end

function Utilities.multi_insert(origin, ...)
    for _, value in ipairs({ ... }) do
        table.insert(origin, value)
    end
end

function Utilities.concatenate_tables(origin, ...)
    local cloned = Utilities.clone_table(origin)

    for _, container in ipairs({ ... }) do
        for _, value in ipairs(container) do
            table.insert(cloned, value)
        end
    end

    return cloned
end

return Utilities
