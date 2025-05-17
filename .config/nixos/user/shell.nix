{
    lib,
    pkgs,
    ...
}: let
    dotfiles = ./../../..;
    dotfiles-xdg = dotfiles + "/.config";
in
    with lib; {
        imports = [
            ./applications/tmux.nix
        ];

        home = {
            file = {
                ".inputrc".text = builtins.readFile (dotfiles + "/.inputrc");
                ".profile".text = builtins.readFile (dotfiles + "/.profile");
            };
            packages = [
                pkgs.fish
            ];
        };
        programs = {
            bash = {
                enable = true;
                initExtra = builtins.readFile (dotfiles + "/.bashrc");
            };

            # TODO: Migrate Fish configuration to Nix because this doesn't work
            # as expected
            fish.generateCompletions = true;
            starship.enable = true;
        };

        xdg.configFile."starship".source = dotfiles-xdg + "/starship";
    }
