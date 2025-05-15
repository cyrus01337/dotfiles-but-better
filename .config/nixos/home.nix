{
    home = {
        homeDirectory = "/home/cyrus";
        stateVersion = "24.05";
        username = "cyrus";
    };

    programs.home-manager.enable = true;
    services.gpg-agent = {
        defaultCacheTtl = 1800;
        enable = true;
        enableSshSupport = true;
    };
}
