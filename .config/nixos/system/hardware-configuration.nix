{lib, ...}: {
    boot = {
        extraModulePackages = [];
        initrd = {
            availableKernelModules = [
                "ata_piix"
                "mptspi"
                "uhci_hcd"
                "ehci_pci"
                "ahci"
                "sd_mod"
                "sr_mod"
            ];
            kernelModules = [];
        };
        kernelModules = [];
    };
    swapDevices = [];

    fileSystems = {
        "/" = {
            # TODO: Move to partitions.nix
            # This will fail if the partition changes but the fix is marginally
            # easier than grabbing UUIDs when trying to copy a UUID in a TTY -
            # human readability and DX FTW
            device = "/dev/sda3";
            fsType = "ext4";
        };
        "/boot" = {
            device = "/dev/sda1";
            fsType = "vfat";
        };
    };
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
    };
    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
