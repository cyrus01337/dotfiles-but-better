#!/usr/bin/env bash
set -e

install_docker() {
    sudo sh -c "$(curl -fsSL https://get.docker.com)"
    sudo usermod -aG docker $USER

    sudo systemctl start --quiet docker.service
}

if ! which docker &> /dev/null; then
    install_docker
fi

cp -f .bashrc $HOME/.bashrc
source .bashrc
