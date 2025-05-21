#!/usr/bin/env bash
set -e

DOTFILES_DIRECTORY="$HOME/Projects/personal/dotfiles-but-better"

function exists() {
    local -a arguments=$@

    for executable in $arguments; do
        if ! which $executable &> /dev/null; then
            return 1
        fi
    done

    return 0
}

function install_docker() {
    if exists curl; then
        sudo sh -c "$(curl -fsSL https://get.docker.com)"
    elif exists wget; then
        sudo sh -c "$(wget -qO - https://get.docker.com)"
    else
        echo "curl/wget not found"

        exit 127
    fi

    sudo usermod -aG docker $USER
    sudo systemctl start --quiet docker.service
}

function install_git() {
    if exists apt-get; then
        sudo apt-get update
        sudo apt-get install -y git
    elif exists dnf; then
        sudo dnf install -y git
    elif exists pacman; then
        sudo pacman -Syu
        sudo pacman -S git
    else
        echo "Unsupported OS"

        exit 127
    fi
}

function install_stow() {
    if exists apt-get; then
        sudo apt-get update
        sudo apt-get install -y stow
    elif exists dnf; then
        sudo dnf install -y stow
    elif exists pacman; then
        sudo pacman -Syu
        sudo pacman -S stow
    else
        echo "Unsupported OS"

        exit 127
    fi
}

if [[ ! -d /etc/nixos ]]; then
    if ! exists docker; then
        install_docker
    fi

    if ! exists git; then
        install_git
    fi

    if ! exists stow; then
        install_stow
    fi

    mkdir -p $(dirname $DOTFILES_DIRECTORY)
    git clone --recurse-submodules git@github.com:cyrus01337/dotfiles-but-better.git $DOTFILES_DIRECTORY
    rm $HOME/.bashrc
else
    if [[ -f "$HOME/.bashrc" ]]; then
        rm "$HOME/.bashrc"
    fi

    if [[ -d "$HOME/.config/fish" ]]; then
        rm -r "$HOME/.config/fish"
    fi
fi

stow -t $HOME -d $DOTFILES_DIRECTORY --adopt .
source $HOME/.bashrc

