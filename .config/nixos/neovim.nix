{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        neovim

        alejandra
        ast-grep
        cargo
        eslint
        fd
        fzf
        gcc
        gnumake
        go
        julia
        lua51Packages.jsregexp
        lua51Packages.lua
        lua51Packages.luarocks
        nodePackages.prettier
        php83Packages.composer
        php83Packages.php-cs-fixer
        prettierd
        python311Packages.black
        python311Packages.isort
        ripgrep
        stylua
        typescript-language-server
        vscode-langservers-extracted
        zulu

        # TODO: Simplify?
        (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
            # meta

            ## (neo)vim
            p.vim
            p.vimdoc
            p.regex
            p.markdown_inline

            ## project management
            p.gitignore
            p.gitcommit
            p.markdown

            # web dev

            ## front-end
            p.html
            p.css
            p.javascript
            p.vim-jsx-typescript
            p.typescript
            p.astro

            ## back-end
            p.php
            p.sql

            # dev-ops
            p.dockerfile

            # software/cli
            p.bash
            p.python
            p.lua

            # general
            p.go
            p.nix

            # configuration formats
            p.json
            p.jsonc
            p.yaml
            p.toml

            # documentation
            p.markdown
        ]))
    ];
}
