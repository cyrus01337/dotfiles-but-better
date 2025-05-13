{pkgs, ...}: {
    imports = [
        ./neovim.nix
    ];

    environment.systemPackages = with pkgs; [
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
    ];
}
