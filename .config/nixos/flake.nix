{
    description = "NixOS Configuration (but a flake!)";

    inputs = {
        home-manager = {
            url = "github:nix-community/home-manager";

            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    outputs = {
        home-manager,
        nixpkgs,
        ...
    } @ inputs: {
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
            modules = [
                home-manager.nixosModules.home-manager
                {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;

                        users.cyrus = ./home.nix;
                    };
                }

                ./configuration.nix
            ];
            system = "x86_64-linux";
        };
    };
}
