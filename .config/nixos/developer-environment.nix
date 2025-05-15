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
            parallel
        ];
        file.".gitconfig".source = ./../../.gitconfig;
    };
    programs = {
        gh.enable = true;
        git.enable = true;
        lazydocker.enable = true;
        lazygit.enable = true;
        ssh.enable = true;
        tmux.enable = true;
    };

    services.gpg-agent = {
        defaultCacheTtl = 1800;
        enable = true;
        enableSshSupport = true;
    };
    xdg.configFile = {
        "lazygit".source = ./../lazygit;
        "tmux".source = ./../tmux;
    };
}
