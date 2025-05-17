{pkgs, ...}: {
    home.packages = [pkgs.alacritty];
    programs.alacritty.enable = true;
}
