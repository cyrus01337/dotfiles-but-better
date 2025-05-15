{
    nix = {
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
        };
        settings = {
            auto-optimise-store = true;
            experimental-features = [
                "nix-command"
                "flakes"
            ];
            use-xdg-base-directories = true;
            warn-dirty = false;
        };
    };
    # TODO: https://nixos.org/manual/nixos/unstable/#sec-upgrading-automatic
    system = {
        autoUpgrade = {
            allowReboot = true;
            enable = true;
        };
        stateVersion = "24.05";
    };

    environment.sessionVariables = rec {
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";
    };
    nixpkgs.config.allowUnfree = true;
}
