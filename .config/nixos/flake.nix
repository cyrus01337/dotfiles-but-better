{
    description = "NixOS Configuration (but a flake!)";

    inputs = {
        home-manager = {
            url = "github:nix-community/home-manager/master";

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
                # TODO: Convert into flake and simplify import
                home-manager.nixosModules.home-manager
                {
                    home-manager = {
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
