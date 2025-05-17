{
    lib,
    pkgs,
    ...
}: let
    dotfiles = ./../../..;
    dotfiles-xdg = dotfiles + "/.config";
in
    with lib; {
        home = {
            file = {
                ".inputrc".text = builtins.readFile (dotfiles + "/.inputrc");
                ".profile".text = builtins.readFile (dotfiles + "/.profile");
            };
            packages = with pkgs; [
                fish
                tmux
            ];
        };
        programs = {
            bash = {
                enable = true;
                initExtra = builtins.readFile (dotfiles + "/.bashrc");
            };
            tmux = {
                aggressiveResize = true;
                baseIndex = 1;
                disableConfirmationPrompt = true;
                enable = true;
                escapeTime = 0;
                extraConfig = builtins.readFile (dotfiles-xdg + "/tmux/tmux.conf");
                focusEvents = true;
                historyLimit = 100000;
                mouse = true;
                newSession = true;
                plugins = with pkgs.tmuxPlugins; [
                    {
                        extraConfig = ''
                            set -g @dracula-plugins false
                            set -g @dracula-show-left-icon session
                        '';
                        plugin = dracula;
                    }
                    vim-tmux-navigator
                ];
                prefix = "C-Space";
                terminal = "tmux-256color";
            };

            fish.generateCompletions = true;
            starship.enable = true;
        };

        xdg.configFile = {
            # TODO: Migrate Fish configuration to Nix because this doesn't work
            # as expected
            "fish".source = dotfiles-xdg + "/fish";
            "starship".source = dotfiles-xdg + "/starship";
        };
    }
