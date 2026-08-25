local PRETTIER = { "prettierd", "prettier", stop_at_first = true }
local HIDDEN_OBJECT_PATHS = {
    "^.zcompdump.*",
    "^.Trash-.*",
    "^.git$",
}
local group = vim.api.nvim_create_augroup("Hyperfocus", {})

local function is_always_hidden(name, _)
    if name == ".." then
        return true
    end

    for _, path in ipairs(HIDDEN_OBJECT_PATHS) do
        if name:match(path) then
            return true
        end
    end

    return false
end

---@param ... string | vim.pack.Spec
local function vim_pack_helper(...)
    local URL_TEMPLATE = "https://github.com/"
    ---@type vim.pack.Spec[]
    local resolved = {}

    for _, object in ipairs({ ... }) do
        if type(object) == "string" then
            local shorthandPackageName = object

            table.insert(resolved, { src = URL_TEMPLATE .. shorthandPackageName })
        elseif type(object) == "table" then
            local spec = object
            spec.src = URL_TEMPLATE .. spec.src

            table.insert(resolved, spec)
        end
    end

    vim.pack.add(resolved)
end

vim_pack_helper(
    "Mofiqul/dracula.nvim",
    "stevearc/oil.nvim",
    { src = "nvim-mini/mini.icons", version = "stable" },
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "christoomey/vim-tmux-navigator",
    "cappyzawa/trim.nvim",
    "stevearc/conform.nvim",
    "MunifTanjim/nui.nvim",
    "folke/noice.nvim",
    "Saghen/blink.lib",
    "Saghen/blink.cmp",
    "Saghen/blink.pairs",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "folke/todo-comments.nvim",
    "arborist-ts/arborist.nvim",
    "windwp/nvim-ts-autotag",
    "m-demare/hlargs.nvim",
    "lewis6991/gitsigns.nvim",
    "folke/persistence.nvim",
    "sQVe/sort.nvim",
    "junegunn/limelight.vim",
    "kylechui/nvim-surround",
    "JoosepAlviste/nvim-ts-context-commentstring",
    "numToStr/Comment.nvim",
    "brenton-leighton/multiple-cursors.nvim",
    "lewis6991/gitsigns.nvim",
    "nvim-tree/nvim-web-devicons",
    "romgrk/barbar.nvim"
)

local blink = require("blink.cmp")
local blink_pairs = require("blink.pairs")
local persistence = require("persistence")

blink.build():wait(60000)
blink.setup({
    completion = {
        trigger = {
            show_on_blocked_trigger_characters = { "." },
        },
    },
    keymap = {
        preset = "super-tab",
        ["<CR>"] = { "accept", "fallback" },
    },
    signature = { enabled = true },
    sources = {
        default = { "snippets", "lsp" },
        providers = {
            snippets = {
                opts = {
                    extended_filetypes = {
                        luau = { "lua" },
                    },
                    search_paths = {
                        vim.fn.stdpath("config") .. "/snippets",
                        vim.fn.getcwd() .. "/snippets",
                    },
                },
            },
        },
    },
})
blink_pairs.build():pwait(60000)
blink_pairs.setup()
persistence.setup({
    options = { "globals" },
    pre_save = function()
        vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
    end,
})

-- require("gemini").setup({
--     completion = {
--         enabled = false,
--     },
--     model_config = {
--         model_id = "gemini-3.1-pro",
--     },
-- })
require("gitsigns").setup()
require("nvim-web-devicons").setup()
require("barbar").setup({
    auto_hide = 1,
    buffer_number = true,
    clickable = false,
    exclude_name = { "nvim" },
    icons = {
        buffer_index = true,
        inactive = {
            button = "",
        },
    },
    insert_at_end = true,
    no_name_title = "Untitled",
    preset = "slanted",
    separator_at_end = true,
})
require("multiple-cursors").setup()
require("ts_context_commentstring").setup({
    enable_autocmd = false,
})
require("Comment").setup({
    extra = {
        above = "<Nop>",
        below = "<Nop>",
        eol = "<Nop>",
    },
    ignore = "^ *$",
    mappings = {
        basic = true,
        extra = false,
    },
    opleader = {
        line = "<Nop>",
        block = "<Nop>",
    },
    padding = true,
    post_hook = function(...) end,
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    sticky = true,
    toggler = {
        line = "cl",
        block = "cb",
    },
})
require("nvim-surround").setup()
require("sort").setup()
require("gitsigns").setup()
require("arborist").setup()
require("todo-comments").setup()
require("hlargs").setup()
require("dracula").setup({
    transparent_bg = true,
})

require("nvim-ts-autotag").setup()
require("noice").setup({
    lsp = {
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
    },
    presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
    },
})
require("trim").setup({
    highlight = false,
    trim_last_line = false,
})
require("conform").setup({
    formatters_by_ft = {
        javascript = PRETTIER,
        javascriptreact = PRETTIER,
        lua = { "stylua" },
        luau = { "stylua" },
        nix = { "alejandra" },
        php = { "php-cs-fixer" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
        typescript = PRETTIER,
        typescriptreact = PRETTIER,
    },
    format_on_save = {
        lsp_fallback = true,
        timeout_ms = 2500,
    },
})
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
    auto_update = true,
    ensure_installed = {
        "beautysh",
        "css-variables-language-server",
        "stylua",
        "ts-standard",

        "alejandra",
        "ast_grep",
        "astro",
        "basedpyright",
        "bashls",
        "cssls",
        "eslint",
        "fish_lsp",
        "gopls",
        "html",
        "jsonls",
        "lua_ls",
        "luau_lsp",
        "pylsp",
        "tailwindcss",
        "taplo",
        "ts_ls",
        "vuels",
        "yamlls",
    },
    integrations = {
        ["mason-lspconfig"] = true,
        ["mason-nvim-dap"] = false,
        ["mason-null-ls"] = false,
    },
})
require("dracula").setup({
    transparent_bg = true,
})
require("mini.icons").setup()
require("oil").setup({
    default_file_explorer = true,
    delete_to_trash = true,
    keymaps = {
        ["<CR>"] = "actions.select",
        ["p"] = "actions.preview",
        ["q"] = "actions.close",
        ["r"] = "actions.refresh",
        ["<BS>"] = "actions.parent",
        ["~"] = "actions.open_cwd",
        ["<C-H>"] = "actions.toggle_hidden",
    },
    use_default_keymaps = false,
    view_options = {
        is_always_hidden = is_always_hidden,
        show_hidden = true,
    },
    watch_for_changes = true,
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.schedule(persistence.load)
    end,
    group = vim.api.nvim_create_augroup("SessionRestore", { clear = true }),
    nested = true,
})

vim.api.nvim_create_autocmd("InsertEnter", {
    group = group,
    pattern = "*",
    callback = function()
        vim.cmd("Limelight")
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    group = group,
    pattern = "*",
    callback = function()
        vim.cmd("Limelight!")
    end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buffer].filetype == "oil" then
                vim.api.nvim_buf_delete(buffer, { force = true })
            end
        end
    end,
})

vim.cmd("colorscheme dracula")
vim.lsp.enable({
    "ast_grep",
    "astro",
    "basedpyright",
    "bashls",
    "css-variables-language-server",
    "cssls",
    "fish_lsp",
    "gopls",
    "html",
    "jsonls",
    "lua_ls",
    "luau_lsp",
    "pylsp",
    "ruff",
    "tailwindcss",
    "taplo",
    "ts_ls",
    "vuels",
    "yamlls",
})
