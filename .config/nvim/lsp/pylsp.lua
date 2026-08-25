---@type vim.lsp.Config
return {
    cmd = { "pylsp" },
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        ".git",
    },
    settings = {
        pylsp = {
            plugins = {
                autopep8 = { enabled = false },
                black = { enabled = false },
                flake8 = { enabled = false },
                jedi_hover = { enabled = false },
                mccabe = { enabled = false },
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
                pylsp_black = { enabled = false },
                pylsp_isort = { enabled = false },
                pylsp_mypy = { enabled = false },
                rope_hover = { enabled = false },
                yapf = { enabled = false },
            },
        },
    },
}
