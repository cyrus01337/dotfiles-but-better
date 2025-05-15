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
        file.".gitconfig".source = ./../../.gitconfig;
    };
    programs = {
        git.enable = true;
        ssh.enable = true;
    };

    services.gpg-agent = {
        defaultCacheTtl = 1800;
        enable = true;
        enableSshSupport = true;
    };
}
