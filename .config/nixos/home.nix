{pkgs, ...}: {
    imports = [
        ./user/desktop-configuration.nix
        ./user/developer-environment.nix
        ./user/shell.nix
    ];

    home = {
        homeDirectory = "/home/cyrus";
        packages = with pkgs; [
            alacritty
            dive
            firefox
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

        alacritty.enable = true;
        bat.enable = true;
        fd.enable = true;
        firefox.enable = false;
        home-manager.enable = true;
        man.enable = true;
        ripgrep.enable = true;
    };
}
