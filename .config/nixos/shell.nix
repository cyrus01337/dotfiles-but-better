{
    lib,
    pkgs,
    ...
}: let
    dotfiles = ./../..;
    dotfiles-xdg = dotfiles + "/.config";
in
    with lib; {
        programs = {
            bash = {
                enable = true;
                initExtra = builtins.readFile ./../../.bashrc;
            };
            fish = {
                enable = true;
                generateCompletions = true;
                # plugins = with pkgs.fishPlugins; [
                #     fzf
                # ];
            };

            starship.enable = true;
        };

        home = {
            file = {
                ".inputrc".text = builtins.readFile ./../../.inputrc;
                ".profile".text = builtins.readFile ./../../.profile;
            };
        };
        xdg.configFile = {
            "fish".source = dotfiles-xdg + "/fish";
            "starship".source = dotfiles-xdg + "/starship";
        };
    }
