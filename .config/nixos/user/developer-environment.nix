{pkgs, ...}: {
    imports = [
        ./editors.nix
    ];

    home = {
        packages = with pkgs; [
            docker
            docker-compose
            iproute2
            jq
            nerd-fonts.fantasque-sans-mono
            parallel
        ];

        file.".gitconfig".source = ./../../../.gitconfig;
        file.".ssh/config".source = ./../../../.ssh/config;
    };
    programs = {
        gh.enable = true;
        git.enable = true;
        lazydocker.enable = true;
        lazygit.enable = true;
        ssh.enable = true;
        tmux.enable = true;
    };

    fonts.fontconfig.enable = true;
    services.gpg-agent = {
        defaultCacheTtl = 1800;
        enable = true;
        enableSshSupport = true;
    };
    xdg.configFile = {
        "lazygit".source = ./../../lazygit;
        "tmux".source = ./../../tmux;
    };
}
