{pkgs, ...}: let
    shared = import ./../shared.nix;
in {
    imports = [
        ./editors.nix
    ];

    home = {
        packages = with pkgs; [
            bun
            docker
            docker-compose
            iproute2
            jq
            lazydocker
            nerd-fonts.fantasque-sans-mono
            nodejs
            parallel
            php83
            python311
        ];

        file.".gitconfig".source = shared.dotfiles + "/.gitconfig";
    };
    programs = {
        gh.enable = true;
        git.enable = true;
        lazydocker.enable = true;
        lazygit.enable = true;
    };

    fonts.fontconfig.enable = true;
    services.gpg-agent = {
        defaultCacheTtl = 1800;
        enable = true;
        enableSshSupport = true;
    };
    xdg.configFile."lazygit".source = shared.dotfiles-xdg + "/lazygit";
}
