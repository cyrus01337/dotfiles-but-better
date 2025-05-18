{pkgs, ...}: let
    backup-graphical-editor = pkgs.vscode;
in {
    imports = [
        ./applications/neovim.nix
    ];

    home.packages = [
        backup-graphical-editor
    ];
}
