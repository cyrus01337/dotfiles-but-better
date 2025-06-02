{pkgs, ...}: {
    home.packages = with pkgs; [
        fish
        tmux
    ];
    programs.starship.enable = true;
}
