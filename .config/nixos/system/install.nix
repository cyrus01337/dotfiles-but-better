{
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
        kernelModules = [];
        kernelPackages = pkgs.linuxPackages_zen;
    };
    swapDevices = [];

    fileSystems."/" = {
        device = "/dev/sda3";
        fsType = "ext4";
    };
    networking.hostName = "nixos";
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    security.sudo.wheelNeedsPassword = false;
    users.users.cyrus = {
        extraGroups = [
            "wheel"
        ];
        isNormalUser = true;
    };
}
