{
    lib,
    pkgs,
    ...
}: let
    inherit lib;

    shared = import ./../shared.nix;
in {
    imports = [
        ./applications/tmux.nix
    ];

    home = {
        file = {
            ".inputrc".text = builtins.readFile (shared.dotfiles + "/.inputrc");
            ".profile".text = builtins.readFile (shared.dotfiles + "/.profile");
        };
        packages = [
            pkgs.fish
        ];
    };
    programs = {
        bash = {
            enable = true;
            initExtra = builtins.readFile (shared.dotfiles + "/.bashrc");
        };

        # TODO: Migrate Fish configuration to Nix because this doesn't work
        # as expected
        fish.generateCompletions = true;
        starship.enable = true;
    };

    xdg.configFile."fish".source = shared.dotfiles-xdg + "/fish";
    xdg.configFile."starship".source = shared.dotfiles-xdg + "/starship";
}
