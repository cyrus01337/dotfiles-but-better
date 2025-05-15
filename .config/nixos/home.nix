{pkgs, ...}: {
    imports = [
        ./developer-environment.nix
        ./shell.nix
    ];

    home = {
        homeDirectory = "/home/cyrus";
        packages = with pkgs; [
            fd
            fzf
            ripgrep
        ];
        preferXdgDirectories = true;
        stateVersion = "24.05";
        username = "cyrus";
    };

    programs = {
        firefox.enable = true;
        fzf.enable = true;
        home-manager.enable = true;
        man.enable = true;
    };
}
