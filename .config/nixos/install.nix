{lib, pkgs, ...}: {
    boot = {
        extraModulePackages = [];
        initrd = {
            kernelModules = [];
            availableKernelModules = [
                "ata_piix"
                "mptspi"
                "uhci_hcd"
                "ehci_pci"
                "ahci"
                "sd_mod"
                "sr_mod"
            ];
        };
        loader = {
            efi.canTouchEfiVariables = true;
            systemd-boot.enable = true;
        };
        kernelModules = [];
    };
    swapDevices = [];

    fileSystems."/" = {
        device = "/dev/sda3";
        fsType = "ext4";
    };
    networking.hostName = "nixos";
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    security.sudo.wheelNeedsPassword = false;
    system.stateVersion = "24.05";
    users.users.cyrus = {
        extraGroups = [
            "wheel"
        ];
        isNormalUser = true;
    };
}
