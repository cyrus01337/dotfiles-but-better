{pkgs, ...}: {
    environment = {
        systemPackages = with pkgs; [
            kdePackages.qtmultimedia
        ];

        plasma6.excludePackages = with pkgs.kdePackages; [
            elisa
            gwenview
            khelpcenter
            kinfocenter
            kmenuedit
            konsole
            okular
            oxygen
            spectacle
        ];
    };
    services = {
        displayManager = {
            autoLogin = {
                enable = true;
                user = "cyrus";
            };
            defaultSession = "plasma";
            sddm = {
                enable = true;

                wayland.enable = true;
            };
        };
        xserver = {
            enable = true;

            desktopManager.xterm.enable = false;
        };

        desktopManager.plasma6 = {
            enable = true;
            enableQt5Integration = false;
        };
    };
}
