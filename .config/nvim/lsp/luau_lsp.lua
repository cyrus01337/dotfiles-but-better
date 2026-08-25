local function get_global_types_path()
    return vim.fn.stdpath("config") .. "/lsp/luau/globalTypes.d.luau"
end

---@type vim.lsp.Config
return {
    cmd = {
        "luau-lsp",
        "lsp",
        "--definitions:@roblox=" .. get_global_types_path(),
    },
    filetypes = { "luau" },
    root_markers = { ".git", "default.project.json" },
    settings = {
        ["luau-lsp"] = {
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
