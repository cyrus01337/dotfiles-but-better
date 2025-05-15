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

        (vimPlugins.nvim-treesitter.withPlugins (p:
            with p; [
                # meta

                ## (neo)vim
                vim
                vimdoc
                regex
                markdown_inline

                ## project management
                gitignore
                gitcommit
                markdown

                # web dev

                ## front-end
                html
                css
                javascript
                vim-jsx-typescript
                typescript
                astro

                ## back-end
                php
                sql

                # dev-ops
                dockerfile

                # software/cli
                bash
                python
                lua

                # general
                go
                nix

                # configuration formats
                json
                jsonc
                yaml
                toml

                # documentation
                markdown
            ]))
    ];
}
