{
    lib,
    pkgs,
    self,
    ...
}: {
    imports = [
        ./user/desktop-configuration.nix
        ./user/developer-environment.nix
        ./user/shell.nix
    ];

    home = {
        homeDirectory = "/home/cyrus";
        packages = with pkgs; [
            alacritty
            bat
            dive
            fd
            fsearch
            man
            ranger
            ripgrep
            stow
        ];
        preferXdgDirectories = true;
        stateVersion = "24.05";
        username = "cyrus";
    };
    programs = {
        fzf = {
            enable = true;
            enableFishIntegration = true;
        };

        firefox.enable = false;
        home-manager.enable = true;
    };
}
