{pkgs, ...}: {
    programs.neovim = {
        enable = true;
        extraPackages = with pkgs; let
            lua-packages = with lua51Packages; [
                jsregexp
                lua
            ];
            developer-tool-packages = [
                alejandra
                eslint
                nodePackages.prettier
                php83Packages.composer
                php83Packages.php-cs-fixer
                prettierd
                stylua
            ];
            treesitter-packages = [
                ast-grep

                (vimPlugins.nvim-treesitter.withPlugins
                (epkgs:
                    with epkgs; [
                        astro
                        bash
                        css
                        dockerfile
                        fish
                        gitcommit
                        gitignore
                        go
                        html
                        javascript
                        json
                        jsonc
                        lua
                        markdown
                        markdown_inline
                        nix
                        php
                        python
                        regex
                        sql
                        toml
                        typescript
                        vim
                        vim-jsx-typescript
                        vimdoc
                        yaml
                    ]))
            ];
            lsp-packages = [
                nil
                typescript-language-server
                vscode-langservers-extracted
            ];
        in
            lua-packages
            ++ developer-tool-packages
            ++ treesitter-packages
            ++ lsp-packages;
        extraPython3Packages = pypkgs:
            with pypkgs; [
                black
                isort
            ];
        withNodeJs = true;
        withPython3 = true;
    };
}
