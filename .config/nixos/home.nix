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

    programs.home-manager.enable = true;
}
