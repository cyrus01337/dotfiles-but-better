#!/usr/bin/env bash
set -e

EMPTY=""
cached_package_manager=$EMPTY
updated_package_manager=false

function exists() {
    local -a arguments=$@

    for executable in $arguments; do
        if ! which $executable &> /dev/null; then
            return 1
        fi
    done

    return 0
}

function install_packages() {
    local -a packages=("$@")

    if [[ $cached_package_manager == $EMPTY ]]; then
        if exists apt-get; then
            cached_package_manager="apt-get"
        elif exists dnf; then
            cached_package_manager="dnf"
        else
            echo "Unsupported OS"

            return 127
        fi
    fi

    if [[ $updated_package_manager == false ]]; then
        updated_package_manager=true

        sudo $cached_package_manager update
    fi

    sudo $cached_package_manager install -y $package

    local exit_code=$?

    return $exit_code
}

install_docker() {
    if exists curl; then
        sudo sh -c "$(curl -fsSL https://get.docker.com)"
    elif exists wget; then
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

if ! which git &> /dev/null; then
    install_package git
fi

if which curl &> /dev/null; then
    curl -fsSL https://github.com/cyrus01337/dotfiles-but-better/raw/refs/heads/main/.bashrc -o $HOME/.bashrc
elif which wget &> /dev/null; then
    wget -qO $HOME/.bashrc https://github.com/cyrus01337/dotfiles-but-better/raw/refs/heads/main/.bashrc
fi

source $HOME/.bashrc
