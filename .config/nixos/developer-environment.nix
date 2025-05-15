{pkgs, ...}: {
    imports = [
        ./neovim.nix
    ];

    home = {
        packages = with pkgs; [
            bun
            docker
            docker-compose
            iproute2
            jq
            lazydocker
            nodejs
            parallel
            php83
            python311
            vscode
        ];
    };

    services.gpg-agent = {
        defaultCacheTtl = 1800;
        enable = true;
        enableSshSupport = true;
    };
}
