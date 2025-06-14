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
    },
    NO_CONFIGURATION_LSPS = { "pyright" },
    THEME = {
        package = "Mofiqul/dracula.nvim",
        name = "dracula",
    },
}
