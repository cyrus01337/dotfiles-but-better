-- TODO: Break out groups of keybinds into their own modules
local constants = require("custom.lib.constants")
local mode = require("custom.lib.mode")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local set = vim.keymap.set

local function save_cursor_column()
    local previous_column_offset = vim.api.nvim_win_get_cursor(0)[2]
    local previous_column = previous_column_offset + 1

    return function()
        local current_row_offset, current_column_offset = unpack(vim.api.nvim_win_get_cursor(0))
        local current_column = current_column_offset + 1

        if previous_column == current_column then
            return
        end

        vim.api.nvim_win_set_cursor(0, { current_row_offset, previous_column_offset })
    end
end

-- disable highlight
set(mode.NORMAL, "<leader>n", "<CMD>nohl<CR>", { remap = true })

-- delete previous word
set(mode.INSERT, "<C-BS>", "db", { remap = true })

-- ctrl+up/down jump through paragraphs/functions
set(mode.NORMAL, "<C-Up>", "{", { remap = true })
set(mode.NORMAL, "<C-Down>", "}", { remap = true })

-- move to start and end of file
set({ mode.NORMAL, mode.INSERT }, "jtb", "gg^", { remap = true })
set({ mode.NORMAL, mode.INSERT }, "jte", "G$", { remap = true })

-- B/E to jump from Beginning/End of line respectively
set(mode.NORMAL, "E", "$", { remap = true })
set(mode.NORMAL, "B", "^", { remap = true })

-- newline on enter in normal mode
set(mode.NORMAL, "<CR>", "o<Esc>", { remap = true })

-- undo
set({ mode.NORMAL, mode.INSERT }, "<C-z>", function()
    vim.cmd("normal! u")
end)

-- redo
set({ mode.NORMAL, mode.INSERT }, "<CS-z>", function()
    vim.cmd("normal! r")
end)

-- rebind delete/cut line
set(mode.NORMAL, "dd", "<Nop>")
set(mode.NORMAL, "dl", "dd")

-- view project files
set(mode.NORMAL, "<leader><Esc>", string.format("<CMD>%s<CR>", constants.FILE_MANAGER))

-- buffer navigation
set(mode.NORMAL, "<leader>1", "<CMD>BufferGoto 1<CR>")
set(mode.NORMAL, "<leader>2", "<CMD>BufferGoto 2<CR>")
set(mode.NORMAL, "<leader>3", "<CMD>BufferGoto 3<CR>")
set(mode.NORMAL, "<leader>4", "<CMD>BufferGoto 4<CR>")
set(mode.NORMAL, "<leader>5", "<CMD>BufferGoto 5<CR>")
set(mode.NORMAL, "<leader>6", "<CMD>BufferGoto 6<CR>")
set(mode.NORMAL, "<leader>7", "<CMD>BufferGoto 7<CR>")
set(mode.NORMAL, "<leader>8", "<CMD>BufferGoto 8<CR>")
set(mode.NORMAL, "<leader>9", "<CMD>BufferGoto 9<CR>")
set(mode.NORMAL, "<leader>0", "<CMD>BufferGoto 10<CR>")

-- save buffer via keybind
set(mode.NORMAL, "<C-s>", "<CMD>w<CR>", { remap = true })
set({ mode.INSERT, mode.VISUAL_SELECT }, "<C-s>", "<CMD>w<CR>", { remap = true })
set(mode.NORMAL, "<CS-s>", "<CMD>wa<CR>", { remap = true })
set({ mode.INSERT, mode.VISUAL_SELECT }, "<CS-s>", "<CMD>wa<CR>", { remap = true })

-- close buffer
set(mode.ALL, "<C-w>", "<CMD>bdelete<CR>")
set({ mode.NORMAL, mode.VISUAL_SELECT }, "<leader>w", "<CMD>bdelete<CR>")
set(mode.ALL, "<CS-w>", "<CMD>bdelete!<CR>")
set({ mode.NORMAL, mode.VISUAL_SELECT }, "<leader><S-w>", "<CMD>bdelete!<CR>")

-- easy case conversion
set(mode.VISUAL_SELECT, "l", "gu", { remap = true })
set(mode.VISUAL_SELECT, "u", "gU", { remap = true })

-- window-splitting/pane creation
set(mode.NORMAL, "<leader>h", string.format("<CMD>split +%s<CR>", constants.FILE_MANAGER))
set(mode.NORMAL, "<leader>v", string.format("<CMD>vsplit +%s<CR>", constants.FILE_MANAGER))

-- duplicate line
set(mode.NORMAL, "yp", function()
    local reset_cursor_column = save_cursor_column()

    vim.cmd("normal! yyp")
    reset_cursor_column()
end)

set(mode.NORMAL, "yP", function()
    local reset_cursor_column = save_cursor_column()

    vim.cmd("normal! yyP")
    reset_cursor_column()
end)

-- select all
set({ mode.NORMAL, mode.VISUAL_SELECT }, "<C-a>", function()
    -- vim motion to go to the start of a file, enter visual mode, then go to
    -- the end of the file
    --
    -- moonicus runicus
    vim.cmd("normal! 0ggVG")
end)

-- source current buffer
set(mode.NORMAL, "<leader>x", function()
    -- "%" expands to the local filepath of the currently open buffer relative
    -- to the current working directory of neovim
    --
    -- appending ":t" is the modifier to get the (t)ail of what's being
    -- expanded, resulting in the filename exclusively, so it's all just moon
    -- runes
    --
    -- see ":help expand"
    local current_buffer_filepath = vim.fn.expand("%")
    local current_filename = vim.fn.expand("%:t")

    vim.cmd("source " .. current_buffer_filepath)
    print("Sourced " .. current_filename)
end)

-- rebind leader+o to focus output view
set(mode.NORMAL, "<leader>o", "<CMD>messages<CR>", { remap = true })

-- rebind (r)edo
-- set(mode.NORMAL, "<CS-z>", "<C-r>", { remap = true })
set(mode.NORMAL, "r", "<C-r>", { remap = true })

-- rebind mass indent/dedent
set(mode.NORMAL, "<Tab>", ">>", { remap = true })
set(mode.NORMAL, "<S-Tab>", "<<", { remap = true })
set(mode.VISUAL_SELECT, "<Tab>", ">gv", { remap = true })
set(mode.VISUAL_SELECT, "<S-Tab>", "<gv", { remap = true })

-- sort selection
set({ mode.VISUAL_SELECT }, "<leader>s", "<CMD>'<,'>Sort<CR>", { remap = true })

-- quit
set(mode.NORMAL, "<leader>q", "<CMD>q<CR>")
set(mode.NORMAL, "<C-q>", "<CMD>qa<CR>")
set(mode.NORMAL, "<leader>Q", "<CMD>q!<CR>") -- force
set(mode.NORMAL, "<CS-q>", "<CMD>qa!<CR>") -- force
