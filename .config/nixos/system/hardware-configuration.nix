{lib, ...}: {
    imports = [];

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
    };
    swapDevices = [];

    fileSystems."/" = {
        # TODO: Move to partitions.nix
        # This will fail if the partition changes but the fix is marginally
        # easier than grabbing UUIDs - human readable date FTW
        device = "/dev/sda3";
        fsType = "ext4";
    };
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
    };
    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
