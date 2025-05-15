{
    programs = {
        fish.enable = true;
        starship.enable = true;
    };

    xdg.configFile."fish".source = let dotfiles = ./..; in dotfiles + "/fish";
}
