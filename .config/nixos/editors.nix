{pkgs, ...}:
with pkgs; {
    home.packages = [
        # Backup graphical editor
        vscode
    ];
    programs.neovim = {
        enable = true;
        extraPackages = let
            runtime-packages = [
                bun
                go
                php83
                python311
                zulu
            ];
            lua-packages = with lua51Packages; [
                jsregexp
                lua
            ];
            developer-tool-packages = [
                alejandra
                nodePackages.prettier
                php83Packages.composer
                php83Packages.php-cs-fixer
                prettierd
                stylua
            ];
            treesitter-packages = [
                vimPlugins.nvim-treesitter.withPlugins
                (epkgs:
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
                    ])
            ];
            lsp-packages = [
                typescript-language-server
                vscode-langservers-extracted
            ];
            packages-to-be-organised = [
                ast-grep
            ];
        in
            runtime-packages
            ++ lua-packages
            ++ developer-tool-packages
            # ++ treesitter-packages
            ++ lsp-packages
            ++ packages-to-be-organised;
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
