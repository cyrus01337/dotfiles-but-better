{pkgs, ...}: let
    shared = import ./../../shared.nix;
in {
    programs.neovim = {
        enable = true;
        extraPackages = with pkgs; [
            ast-grep
            lua51Packages.jsregexp
        ];
    };
}
