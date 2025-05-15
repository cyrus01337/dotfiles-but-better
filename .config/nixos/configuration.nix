{
    config,
    pkgs,
    ...
}: {
    imports = [
        ./system/audio.nix
        ./system/bootloader.nix
        ./system/desktop-environment.nix
        ./system/fonts.nix
        ./system/hardware-configuration.nix
        ./system/internationalisation.nix
        ./system/operating-system.nix
        ./system/packages.nix
        ./system/users.nix
        ./system/virtualisation.nix
    ];

    networking = {
        hostName = "nixos";

        networkmanager.enable = true;
    };
    programs = {
        # TODO: Migrate to Bash configuration
        bash.interactiveShellInit = ''
            if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]; then
                shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""

                exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
            fi
        '';
        firefox.enable = true;
    };
    services = {
        openssh.enable = true;
        tailscale.enable = true;
    };
}
