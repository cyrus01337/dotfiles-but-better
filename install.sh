#!/usr/bin/env bash
set -e

REQUIRED_PACKAGES=(curl git stow fish starship tmux docker)
SYSTEM_PACKAGE_MANAGERS=(apt-get dnf pacman)
DEFAULT_SHELL="fish"
INSTALLING_DOCKER_FLAG=false
INSTALLING_STARSHIP_FLAG=false

exists() {
    which $1 &> /dev/null
}

get_system_package_manager() {
    for system_package_manager in ${SYSTEM_PACKAGE_MANAGERS[@]}; do
        if exists $system_package_manager; then
            echo $system_package_manager

            return 0
        fi
    done

    return 127
}

get_packages_to_be_installed_with() {
    system_package_manager=$1

    for package in ${REQUIRED_PACKAGES[@]}; do
        if ! exists $package; then
            if [[ $package = "docker" ]]; then
                INSTALLING_DOCKER_FLAG=true
            elif [[ $package = "starship" ]]; then
                INSTALLING_STARSHIP_FLAG=true
            else
                echo $package
            fi
        fi
    done
}

install_docker() {
    sudo sh -c "$(curl -fsSL https://get.docker.com)"
    sudo usermod -aG docker $USER

    sudo systemctl start --quiet docker.service
}

install_starship() {
    sh -c "$(curl -sS https://starship.rs/install.sh)" -- -y
}

install_using_system_package_manager() {
    system_package_manager=$1
    arguments=("${@:2}")

    if [[ $INSTALLING_DOCKER_FLAG = true ]]; then
        install_docker
    fi

    if [[ $INSTALLING_STARSHIP_FLAG = true ]]; then
        install_starship
    fi

    if [[ $system_package_manager = "apt-get" ]]; then
        sudo $system_package_manager install -y ${arguments[@]}
    elif [[ $system_package_manager = "dnf" ]]; then
        sudo $system_package_manager install -y ${arguments[@]}
    elif [[ $system_package_manager = "pacman" ]]; then
        sudo $system_package_manager -S --noconfirm ${arguments[@]}
    fi
}

system_package_manager=$(get_system_package_manager)
packages_to_be_installed=($(get_packages_to_be_installed_with $system_package_manager))

install_using_system_package_manager $system_package_manager ${packages_to_be_installed[@]}
mkdir -p ~/Projects/personal
git clone https://github.com/cyrus01337/dotfiles-but-better.git ~/Projects/personal/dotfiles
cd ~/Projects/personal/dotfiles
git submodule update --init --recursive
stow . -t ../../../

if [[ $(basename $SHELL) != $DEFAULT_SHELL ]]; then
    echo "Changing default shell to Fish..."

    chsh -s $(which fish)
fi
