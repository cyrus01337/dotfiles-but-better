{
    config,
    pkgs,
    ...
}: {
    imports = [
        ./system/audio.nix
        ./system/bootloader.nix
        # ./system/desktop-environment.nix
        ./system/hardware-configuration.nix
        ./system/internationalisation.nix
        ./system/operating-system.nix
        ./system/packages.nix
        ./system/users.nix
        ./system/virtualisation.nix
    ];

    networking = {
        hostName = "nixos";

        networkmanager.enable = true;
    };
    services = {
        openssh.enable = true;
        tailscale.enable = true;
    };
}
