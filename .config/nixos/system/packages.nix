{pkgs, ...}: {
    documentation.nixos.enable = false;
    environment.systemPackages = with pkgs; [
        alacritty
        fastfetch
        tailscale
        unzip
        vim
        wget
    ];
    services.xserver.excludePackages = [
        pkgs.xterm
    ];
}
