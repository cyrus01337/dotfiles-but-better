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

if ! exists docker; then
    install_docker
fi

if ! exists git; then
    install_git
fi

mkdir -p $(dirname $DOTFILES_DIRECTORY)
git clone --recurse-submodules git@github.com:cyrus01337/dotfiles-but-better.git $DOTFILES_DIRECTORY

if exists curl; then
    curl -fsSL https://github.com/cyrus01337/dotfiles-but-better/raw/refs/heads/main/.bashrc -o $HOME/.bashrc
elif exists wget; then
    wget -qO $HOME/.bashrc https://github.com/cyrus01337/dotfiles-but-better/raw/refs/heads/main/.bashrc
fi

source $HOME/.bashrc
