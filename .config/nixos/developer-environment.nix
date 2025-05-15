{pkgs, ...}: {
    imports = [
        ./editors.nix
    ];

    home = {
        packages = with pkgs; [
            docker
            docker-compose
            gh
            iproute2
            jq
            lazydocker
            lazygit
            parallel
        ];
    };

    services.gpg-agent = {
        defaultCacheTtl = 1800;
        enable = true;
        enableSshSupport = true;
    };
}
