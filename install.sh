#!/usr/bin/env bash
set -e

REQUIRED_PACKAGES=(git stow fish starship tmux docker)
SYSTEM_PACKAGE_MANAGERS=(apt-get dnf pacman)
DEFAULT_SHELL="fish"

exists() {
    which $1 &> /dev/null
}

get_system_package_manager() {
    for $system_package_manager in $SYSTEM_PACKAGE_MANAGERS; do
        if exists $system_package_manager; then
            echo $system_package_manager

            return 0;
        fi
    done

    return 127
}

get_packages_to_be_installed() {
    for package in $REQUIRED_PACKAGES; do
        if ! exists $package; then
            if [[ $package = "docker" ]]; then
                # output docker packages
            else
                echo $package
            fi
        fi
    done
}

install_using_system_package_manager() {
    system_package_manager=$1
    arguments=("${@[@]:1}")

    if [[ $system_package_manager = "apt-get" ]]; then
        $system_package_manager install $arguments
    elif [[ $system_package_manager = "dnf" ]]; then
        $system_package_manager install $arguments
    elif [[ $system_package_manager = "pacman" ]]; then
        $system_package_manager -S $arguments
    fi
}

packages_to_be_installed=($(get_packages_to_be_installed))

install_using_system_package_manager $(get_system_package_manager) $packages_to_be_installed
mkdir -p ~/Projects/personal
git clone https://github.com/cyrus01337/dotfiles-but-better.git ~/Projects/personal/dotfiles
cd ~/Projects/personal/dotfiles
git submodule update --init --recursive
stow . -t ../../../

if [ $SHELL =~ $DEFAULT_SHELL ]; then
    chsh -s $(which fish)
fi
