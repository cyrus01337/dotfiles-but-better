---@type vim.lsp.Config
return {
    cmd = { "ast-grep", "lsp" },
    workspace_required = true,
    reuse_client = function(client, config)
        config.cmd_cwd = config.root_dir
        return client.name == config.name and client.config.cmd_cwd == config.cmd_cwd
    end,
    filetypes = { -- https://ast-grep.github.io/reference/languages.html
        "bash",
        "c",
        "cpp",
        "cs",
        "css",
        "elixir",
        "go",
        "haskell",
        "html",
        "java",
        "javascript",
        "javascriptreact",
        "json",
        "kotlin",
        "lua",
        "nix",
        "php",
        "python",
        "ruby",
        "rust",
        "scala",
        "solidity",
        "swift",
        "typescript",
        "typescriptreact",
        "yaml",
    },
    root_markers = { "sgconfig.yaml", "sgconfig.yml" },
}
