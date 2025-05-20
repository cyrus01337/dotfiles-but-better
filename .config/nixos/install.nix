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
    swapDevices = [
        {
            device = "/dev/sda2";
        }
    ];

    fileSystems."/" = {
        device = "/dev/sda3";
        fsType = "ext4";
    };
    networking.hostName = "nixos";
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    system.stateVersion = "24.05";
    users.users.cyrus = {
        extraGroups = [
            "wheel"
        ];
        isNormalUser = true;
    };
}
