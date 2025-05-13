{pkgs, ...}: {
    # TODO: Simplify?
    fonts.packages = with pkgs; [
        nerd-fonts.fantasque-sans-mono
    ];
}
