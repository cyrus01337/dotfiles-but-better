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
        ts_ls = {
            init_options = {
                preferences = {
                    importModuleSpecifierPreference = "non-relative",
                    preferTypeOnlyAutoImports = true,
                },
            },
        },
    },
    NO_CONFIGURATION_LSPS = {
        "astro",
        "bashls",
        "css_variables",
        "cssls",
        "docker_compose_language_service",
        "dockerls",
        "eslint",
        "gopls",
        "html",
        "jsonls",
        "nixd",
        "phpactor",
        "postgres_lsp",
        "pylsp",
        "rust_analyzer",
        "sqlls",
        "systemd_ls",
        "tailwindcss",
        "ts_ls",
        "yamlls",
    },
    THEME = {
        package = "Mofiqul/dracula.nvim",
        name = "dracula",
    },
}
