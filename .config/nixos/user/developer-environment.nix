{pkgs, ...}: {
    imports = [
        ./editors.nix
    ];

    home.packages = with pkgs; [
        delta
        docker
        docker-compose
        ffmpeg
        iproute2
        jq
        lazydocker
        lazygit
        nerd-fonts.fantasque-sans-mono
        parallel
    ];
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
}
