return {
    cmd = {
        "luau-lsp",
        "lsp",
        "--definitions:@roblox=/home/cyrus/Projects/personal/dotfiles-but-better/.config/nvim/after/lsp/luau/globalTypes.d.luau",
    },
    settings = {
        ["luau-lsp"] = {
            lint = {
                globals = {
                    "delay",
                    "error",
                    "game",
                    "plugin",
                    "print",
                    "script",
                    "shared",
                    "spawn",
                    "tick",
                    "wait",
                    "warn",
                    "workspace",
                },
            },
            platform = {
                type = "roblox",
            },
            plugin = {
                enabled = true,
                port = 3667,
            },
            sourcemap = {
                autogenerate = true,
                enabled = true,
                generator_cmd = { "argon", "sourcemap", "--watch", "--non-scripts" },
            },
        },
    },
}
