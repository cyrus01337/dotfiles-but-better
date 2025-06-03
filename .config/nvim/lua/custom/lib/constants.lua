return {
    EMPTY = "",
    FILE_MANAGER = "Oil",
    LSP_OPTIONS = {
        lua_ls = {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                },
            },
        },
        sourcery = {
            filetypes = { "python" },
            init_options = {
                token = "user_y_c5BVAcYOzPnfPwlzXA3KddRLTISzYRpDOE38YLLztYBefizqkRjrEqNRI",
            },
        },
    },
    THEME = {
        package = "Mofiqul/dracula.nvim",
        name = "dracula",
    },
}
