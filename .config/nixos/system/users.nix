{pkgs, ...}: {
    # Allows passwordless prompts due to my user being in the wheel group
    #
    # Word of warning - never do this on any system ever. I work exclusively in
    # VMs at the time of writing this, so long as it has a connection to the
    # internet or access to potentially sensitive data you must always set
    # passwords for elevated privileges as a general rule of thumb. I simply
    # don't care for this VM, however, if there is ever the intention of
    # carrying this over to bare metal, this option will be removed in it's
    # entirety.
    security.sudo.wheelNeedsPassword = false;
    users.users.cyrus = {
        description = "cyrus";
        extraGroups = [
            "docker"
            "networkmanager"
            "sudo"
            "wheel"
        ];
        hashedPassword = "$y$j9T$Fh/L5Io1pZP6BOYDP0x501$BBfMPoC/uB9RO2t.jO5zdNlKEaKC3JSQrChfIczkAM/";
        isNormalUser = true;
    };
}
