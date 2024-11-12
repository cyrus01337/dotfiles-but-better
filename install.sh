#!/usr/bin/env bash
set -e

install_docker() {
    if which curl &> /dev/null; then
        sudo sh -c "$(curl -fsSL https://get.docker.com)"
    elif which wget &> /dev/null; then
        sudo sh -c "$(wget -qO - https://get.docker.com)"
    else
        echo "You must have curl/wget installed to run this script"

        exit 127
    fi

    sudo usermod -aG docker $USER

    sudo systemctl start --quiet docker.service
}

if ! which docker &> /dev/null; then
    install_docker
fi

if which curl &> /dev/null; then
    curl -fsSL https://github.com/cyrus01337/dotfiles-but-better/raw/refs/heads/main/.bashrc -o $HOME/.bashrc
elif which wget &> /dev/null; then
    wget -qO $HOME/.bashrc https://github.com/cyrus01337/dotfiles-but-better/raw/refs/heads/main/.bashrc
fi

source $HOME/.bashrc
