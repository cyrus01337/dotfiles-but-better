{pkgs, ...}: {
    imports = [
        ./developer-environment.nix
        ./shell.nix
    ];

    home = {
        homeDirectory = "/home/cyrus";
        packages = with pkgs; [
            dive
            fd
            fzf
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

        bat.enable = true;
        firefox.enable = true;
        home-manager.enable = true;
        man.enable = true;
    };
}
