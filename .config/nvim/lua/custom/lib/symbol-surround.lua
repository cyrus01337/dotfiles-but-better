local mode = require("custom.lib.mode")

local symbol_surround = {}

---@param pattern string
---@param text string
---@param column number
---
---@return number?
local function find_nearest_relative_column(pattern, text, column)
    local column_found
    local cycles = -1
    local max_match_length = #pattern

    repeat
        cycles = cycles + 1
        column_found = text:find(pattern, cycles)
    until column_found == nil or math.abs(column_found - column) <= max_match_length

    return column_found
end

---@alias SelectionType "text" | "line"
---@alias Selection { ending_column: number, type: SelectionType, starting_column: number, text: string }
---
---@return Selection?
local function get_current_selection()
    local current_mode_information = vim.api.nvim_get_mode()

    if current_mode_information.mode == mode.NORMAL then return nil end

    local current_line = vim.api.nvim_get_current_line()

    if current_mode_information.mode == mode.VISUAL_LINE then
        local end_of_line_column = #current_line - 1

        -- TODO: Extend with starting and ending positions containing both
        -- lines and columns
        return {
            ending_column = end_of_line_column,
            starting_column = 0,
            text = current_line,
            type = "line",
        }
    end

    local current_selection_position = vim.fn.getpos("v")
    local selection_starting_column = current_selection_position[3]
    local selection_ending_column = vim.api.nvim_win_get_cursor(0)[2]

    return {
        ending_column = selection_ending_column,
        starting_column = selection_starting_column,
        text = current_line:sub(selection_starting_column, selection_ending_column),
        type = "text",
    }
end

---@alias Symbols { [1]: string, [2]: string }
---
---@param symbols string | Symbols
---
---@return string, string
local function parse_symbols(symbols)
    local starting_character = ""
    local ending_character = ""

    if type(symbols) == "table" then
        starting_character, ending_character = unpack(symbols)
    else
        starting_character = symbols
        ending_character = symbols
    end

    return starting_character, ending_character
end

---@param symbols string | Symbols
---@param text string
---@param line string
---@param replace_at_column number
local function surround_with(symbols, text, line, replace_at_column)
    local starting_symbol, ending_symbol = parse_symbols(symbols)
    local head = line:sub(1, replace_at_column - 1)
    local tail = line:sub(replace_at_column + #text)
    local replacement = starting_symbol .. text .. ending_symbol

    vim.api.nvim_set_current_line(head .. replacement .. tail)
end

---@param symbols string | Symbols
---@param selected_word string
---@param line string
---@param replace_at_column number
local function remove_surrounding_characters(symbols, selected_word, line, replace_at_column)
    local starting_symbol, ending_symbol = parse_symbols(symbols)
    local head = line:sub(1, replace_at_column - 1)
    local surrounded_word = starting_symbol .. selected_word .. ending_symbol
    local tail = line:sub(replace_at_column + #surrounded_word)
    local replacement = selected_word

    vim.api.nvim_set_current_line(head .. replacement .. tail)
end

---@param selection Selection
---@param symbols string | Symbols
function symbol_surround.naively_surround_selection(selection, symbols)
    local current_line = vim.api.nvim_get_current_line()
    local starting_symbol, ending_symbol = parse_symbols(symbols)

    if selection.type == "line" then
        local initial_whitespace = current_line:match("^%s*")
        local content = current_line:sub(#initial_whitespace + 1)
        local initial_whitespace_at_column = #initial_whitespace + 1
        local initial_contentful_character = content:sub(1, 1)
        local last_contentful_character = content:sub(-1)

        if initial_contentful_character == starting_symbol and last_contentful_character == ending_symbol then
            remove_surrounding_characters(symbols, content, current_line, initial_whitespace_at_column)
        else
            surround_with(symbols, content, current_line, initial_whitespace_at_column)
        end
    elseif selection.type == "text" then
        surround_with(symbols, selection.text, current_line, selection.starting_column)
    end

    vim.api.nvim_input("<Esc>")
end

---@param word string
---@param symbols string | Symbols
function symbol_surround.surround_word(word, symbols)
    local starting_symbol, ending_symbol = parse_symbols(symbols)
    local current_column = vim.api.nvim_win_get_cursor(0)[2]
    local current_line = vim.api.nvim_get_current_line()
    local surrounded_word = string.format("[%s]%s[%s]", starting_symbol, word, ending_symbol)
    local nearest_surrounding_column_found = find_nearest_relative_column(surrounded_word, current_line, current_column)
    local nearest_word_column_found = find_nearest_relative_column(word, current_line, current_column)

    if nearest_surrounding_column_found then
        remove_surrounding_characters(symbols, word, current_line, nearest_surrounding_column_found)
    elseif nearest_word_column_found then
        surround_with(symbols, word, current_line, nearest_word_column_found)
    end
end

---@param symbols string | Symbols
function symbol_surround.create_callback_surrounding_with(symbols)
    return function()
        local current_selection_found = get_current_selection()
        local currently_selected_word_found = vim.fn.expand("<cword>")

        if current_selection_found then
            symbol_surround.naively_surround_selection(current_selection_found, symbols)
        elseif currently_selected_word_found then
            symbol_surround.surround_word(currently_selected_word_found, symbols)
        end
    end
end

return symbol_surround

