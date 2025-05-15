{pkgs, ...}: {
    fonts.packages = with pkgs.nerd-fonts; [
        fantasque-sans-mono
    ];
}
