{
    description = "NixOS Configuration (but a flake!)";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    outputs = {nixpkgs, ...} @ inputs: {
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
            modules = [
                ./configuration.nix
            ];
            system = "x86_64-linux";
        };
    };
}
