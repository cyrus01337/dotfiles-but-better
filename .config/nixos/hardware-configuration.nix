{
    config,
    lib,
    pkgs,
    modulesPath,
    ...
}: {
    imports = [];

    boot.initrd.availableKernelModules = [
        "ata_piix"
        "mptspi"
        "uhci_hcd"
        "ehci_pci"
        "ahci"
        "sd_mod"
        "sr_mod"
    ];
    boot.initrd.kernelModules = [];
    boot.kernelModules = [];
    boot.extraModulePackages = [];

    fileSystems."/" = {
        # This will fail if the partition changes but the fix is marginally
        # easier than grabbing UUIDs - human readable date FTW
        device = "/dev/sda1";
        fsType = "ext4";
    };

    swapDevices = [];

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
