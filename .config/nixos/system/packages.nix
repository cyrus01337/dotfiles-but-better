{pkgs, ...}: {
    documentation.nixos.enable = false;
    environment.systemPackages = with pkgs; [
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
