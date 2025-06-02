{pkgs, ...}: {
    imports = [
        ./editors.nix
    ];

    home = {
        packages = with pkgs; [
            alejandra
            docker
            docker-compose
            iproute2
            jq
            lazydocker
            lazygit
            lua
            nerd-fonts.fantasque-sans-mono
            nodePackages.prettier
            parallel
            php83Packages.composer
            php83Packages.php-cs-fixer
            prettierd
            stylua
        ];
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
}
