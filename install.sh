#!/usr/bin/env bash
set -e

REQUIRED_PACKAGES=(curl git stow fish starship tmux docker)
SYSTEM_PACKAGE_MANAGERS=(apt-get dnf pacman)
DEFAULT_SHELL="fish"
INSTALLING_DOCKER_FLAG=false

exists() {
    which $1 &> /dev/null
}

get_system_package_manager() {
    for system_package_manager in $SYSTEM_PACKAGE_MANAGERS; do
        if exists $system_package_manager; then
            echo $system_package_manager

            return 0
        fi
    done

    return 127
}

get_packages_to_be_installed_with() {
    system_package_manager=$1

    for package in $REQUIRED_PACKAGES; do
        if ! exists $package; then
            echo $package
        fi
    done
}

get_distro_name() {
    id_like_property="ID_LIKE="
    id_property="ID="
    id_like_property_found=$(cat /etc/os-release | grep -Po "^ID_LIKE=\".+\"")
    id_property_found=$(cat /etc/os-release | grep -Po "^ID=.+")

    if [[ $id_like_property_found ]]; then
        similar_distros=$( $id_like_property_found | sed 's/ID_LIKE="\(.*\)"/\1/' )

        if [[ $similar_distros == *"ubuntu"* ]]; then
            echo "ubuntu"
        else
            echo "debian"
        fi
    elif [[ $id_property_found ]]; then
        stripped_distro_name=$( $id_property_found | sed 's/ID=\(.*\)/\1/' )

        echo $stripped_distro_name
    fi
}

maybe_start_docker_service() {
    if ! sudo systemctl is-active --quiet docker.service; then
        sudo systemctl start docker.service
    fi
}

install_docker_with() {
    system_package_manager=$1

    case $system_package_manager in
        "apt-get")
            distro_name=$(get_distro_name)

            # TODO: Use $distro_name to convert related commands to their
            # respective equivalent based on the distro name
            sudo apt-get update
            sudo apt-get install -y ca-certificates
            sudo install -m 0755 -d /etc/apt/keyrings

            case $distro_name in
                ubuntu)
                    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
                    sudo chmod a+r /etc/apt/keyrings/docker.asc

                    echo \
                        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
                        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
                        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

                    ;;
                debian)
                    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
                    sudo chmod a+r /etc/apt/keyrings/docker.asc

                    echo \
                        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
                        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
                        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

                    ;;
                *)
                    echo "Docker installation for $distro_name is not supported, please create an issue"

                    exit 1

                    ;;
            esac

            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

            ;;
        dnf)
            sudo dnf update
            sudo dnf -y install dnf-plugins-core
            sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

            sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

            ;;
        pacman)
            sudo pacman -Sy
            sudo pacman -S docker

            ;;
    esac

    sudo usermod -aG docker $USER
    maybe_start_docker_service
}

install_using_system_package_manager() {
    system_package_manager=$1
    arguments=("${@:1}")

    if [[ $INSTALLING_DOCKER_FLAG = true ]]; then
        install_docker_with $system_package_manager
    fi

    if [[ $system_package_manager = "apt-get" ]]; then
        $system_package_manager install $arguments
    elif [[ $system_package_manager = "dnf" ]]; then
        $system_package_manager install $arguments
    elif [[ $system_package_manager = "pacman" ]]; then
        $system_package_manager -S $arguments
    fi
}

system_package_manager=$(get_system_package_manager)
packages_to_be_installed=($(get_packages_to_be_installed_with $system_package_manager))

install_using_system_package_manager $(get_system_package_manager) $packages_to_be_installed
mkdir -p ~/Projects/personal
git clone https://github.com/cyrus01337/dotfiles-but-better.git ~/Projects/personal/dotfiles
cd ~/Projects/personal/dotfiles
git submodule update --init --recursive
stow . -t ../../../

if [[ $SHELL =~ $DEFAULT_SHELL ]]; then
    chsh -s $(which fish)
fi
