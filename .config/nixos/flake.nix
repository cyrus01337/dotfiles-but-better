{
    description = "NixOS Configuration (but a flake!)";

    inputs = {
        home-manager = {
            url = "github:nix-community/home-manager/master";

            inputs.nixpkgs.follows = "nixpkgs";
        };
        plasma-manager = {
            inputs = {
                home-manager.follows = "home-manager";
                nixpkgs.follows = "nixpkgs";
            };
            url = "github:nix-community/plasma-manager";
        };

        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    outputs = {
        home-manager,
        nixpkgs,
        plasma-manager,
        ...
    } @ inputs: {
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
            modules = [
                # TODO: Convert into flake and simplify import
                home-manager.nixosModules.home-manager
                {
                    home-manager = {
                        sharedModules = [plasma-manager.homeManagerModules.plasma-manager];
                        useGlobalPkgs = true;

                        users.cyrus = ./home.nix;
                    };
                }
                ./configuration.nix
            ];
            system = "x86_64-linux";
        };
    };
}
