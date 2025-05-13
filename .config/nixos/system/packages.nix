{pkgs, ...}: {
    documentation.nixos.enable = false;
    environment.systemPackages = with pkgs; [
        alacritty
        fastfetch
        flatpak
        tailscale
        unzip
        vim
        wget
    ];
    services.xserver.excludePackages = [
        pkgs.xterm
    ];
}
