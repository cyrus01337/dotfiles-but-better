{
    virtualisation = {
        docker.enable = true;
        vmware.guest.enable = true;
    };

    services.xserver.videoDrivers = ["vmware"];
}
