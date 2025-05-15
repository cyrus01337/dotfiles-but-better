{
    pkgs,
    ...
}: {
    programs.neovim = {
        enable = true;
        extraPackages = let
            luapkgs = with pkgs.lua51Packages; [
                jsregexp
                lua
                luarocks
            ];
        in
            with pkgs;
                luapkgs
                ++ [
                    alejandra
                    ast-grep
                    cargo
                    # eslint
                    gcc
                    gnumake
                    go
                    julia
                    nodePackages.prettier
                    php83Packages.composer
                    php83Packages.php-cs-fixer
                    prettierd
                    stylua
                    typescript-language-server
                    vscode-langservers-extracted
                    zulu

                    (vimPlugins.nvim-treesitter.withPlugins (epkgs:
                        with epkgs; [
                            astro
                            bash
                            css
                            dockerfile
                            gitcommit
                            gitignore
                            go
                            html
                            javascript
                            json
                            jsonc
                            lua
                            markdown
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
        extraPython3Packages = pypkgs:
            with pypkgs; [
                black
                isort
            ];
        withNodeJs = true;
        withPython3 = true;
    };
    xdg.configFile."nvim".source = let dotfiles = ./..; in dotfiles + "/nvim";
}
