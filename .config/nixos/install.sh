#!/usr/bin/env bash
set -e

if [[ ! $SUDO_USER ]]; then
    echo "This script must be run as sudo"

    exit 1
fi

ROOT="/mnt"
NIXOS_CONFIGURATION_DIRECTORY="$ROOT/etc/nixos"
DOTFILES_ARCHIVE_PATH="$NIXOS_CONFIGURATION_DIRECTORY/dotfiles.zip"
NEW_DOTFILES_DIRECTORY="/home/cyrus/Projects/personal"

use_latest_unstable_channel() {
    nix-channel --add https://nixos.org/channels/nixos-unstable nixos \
        && nix-channel --update
}

setup_partitions() {
    curl -fsSLo partitions.nix https://raw.githubusercontent.com/cyrus01337/dotfiles-but-better/refs/heads/main/.config/nixos/system/partitions.nix \
        && nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --yes-wipe-all-disks --mode destroy,format,mount partitions.nix \
        && rm partitions.nix
}

build_with_default_configuration() {
    mkdir -p $NIXOS_CONFIGURATION_DIRECTORY \
        && curl -fsSLo "$NIXOS_CONFIGURATION_DIRECTORY/configuration.nix" https://raw.githubusercontent.com/cyrus01337/dotfiles-but-better/refs/heads/main/.config/nixos/install.nix \
        && curl -fsSLo "$NIXOS_CONFIGURATION_DIRECTORY/default.nix" https://raw.githubusercontent.com/cyrus01337/dotfiles-but-better/refs/heads/main/.config/nixos/default.nix \
        && nix-shell $NIXOS_CONFIGURATION_DIRECTORY --run "nixos-install -j 8 --no-root-password --cores 0"
}

bootstrap_dotfiles() {
    nix-shell -p git --run "git clone https://github.com/cyrus01337/dotfiles-but-better.git $ROOT$NEW_DOTFILES_DIRECTORY/dotfiles-but-better" \
        && nixos-enter --root /mnt --command "chown -R cyrus:users '$NEW_DOTFILES_DIRECTORY/dotfiles-but-better' && nixos-rebuild --flake '$NEW_DOTFILES_DIRECTORY/dotfiles-but-better/.config/nixos#nixos' boot"
}

use_latest_unstable_channel
setup_partitions
build_with_default_configuration
bootstrap_dotfiles

reboot now
