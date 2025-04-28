{
    description = "NixOS Configuration (but a flake!)";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    outputs =
        inputs@{ self, nixpkgs, ... }:
        {
            nixosConfigurations.nix = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix
                ];
            };
        };
}
