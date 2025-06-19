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
                    hint = {
                        enable = true,
                    },
                },
            },
        },
        pyright = {
            settings = {
                pyright = {
                    disableOrganizeImports = true,
                },
                python = {
                    analysis = {
                        ignore = { "*" },
                    },
                },
            },
        },
    },
    NO_CONFIGURATION_LSPS = { "ts_ls" },
    THEME = {
        package = "Mofiqul/dracula.nvim",
        name = "dracula",
    },
}
