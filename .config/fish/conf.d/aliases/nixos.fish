#!/usr/bin/env fish
if test (cat /etc/os-release | grep "NixOS")
    function nixos-rebuild-extended --wraps "nixos-rebuild"
        set NIXOS_CONFIGURATION_DIRECTORY $HOME/Projects/personal/dotfiles-but-better/.config/nixos

        if test -d $HOME/.config/nixos
            set NIXOS_CONFIGURATION_DIRECTORY $HOME/.config/nixos
        end

        set FLAKE_URL "$NIXOS_CONFIGURATION_DIRECTORY#nix"

        sudo nixos-rebuild --flake $FLAKE_URL switch
    end

    alias nr="nixos-rebuild-extended"
end
