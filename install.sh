#!/usr/bin/env bash
# TODO: Add logging
set -e

TEMPORARY_DIRECTORY="$(mktemp -d)"
FEDORA="Fedora"
ARCH="Arch"
NIXOS="NixOS"
OPERATING_SYSTEM="${OPERATING_SYSTEM-$(hostnamectl | grep 'Operating System')}"
INSTALL_FLATPAKS=${INSTALL_FLATPAKS-true}
FLATPAK_SOFTWARE=(
    "app.zen_browser.zen"
    "com.github.PintaProject.Pinta"
    "com.github.taiko2k.tauonmb"
    "com.github.wwmm.easyeffects"
    "com.interversehq.qView"
    "com.visualstudio.code"
    "org.flameshot.Flameshot"
    "org.onlyoffice.desktopeditors"
    "org.videolan.VLC"
    "com.github.tchx84.Flatseal"
)
EXCLUDE_KDE_SOFTWARE=("elisa gwenview khelpcenter kinfocenter konsole spectacle")
ARCH_PACKAGE_MANAGER="yay"
SSH_DIRECTORY="$HOME/.ssh"
BITWARDEN_SESSION_TOKEN="$BITWARDEN_SESSION_TOKEN"

export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"

is_operating_system() {
    # Without double brackets the same line using "test" reports the wrong exit
    # code (for some reason), so here it is embraced as a sole inconsistency
    [[ $OPERATING_SYSTEM == *"$1"* ]]
}

upgrade_system() {
    if is_operating_system $FEDORA; then
        sudo dnf upgrade -y
    elif is_operating_system $ARCH; then
        $ARCH_PACKAGE_MANAGER -Syu --needed --noconfirm
    fi
}

setup_yay() {
    # TODO: Move to $HOME/bin/yay
    sudo install --directory --mode 757 /opt/yay && \
        git clone https://aur.archlinux.org/yay.git /opt/yay && \
        env GOFLAGS=-buildvcs=false makepkg -cfirsC --needed --noconfirm --dir /opt/yay && \
        yay --cleanafter --removemake --save --answerclean all --answerdiff none --answeredit none --answerupgrade all
}

install_package() {
    if is_operating_system $FEDORA; then
        sudo dnf install -y $@
    elif is_operating_system $ARCH; then
        $ARCH_PACKAGE_MANAGER -S --needed --noconfirm $@
    fi
}

remove_package() {
    if is_operating_system $FEDORA; then
        sudo dnf remove -y $@ 2> /dev/null
    elif is_operating_system $ARCH; then
        $ARCH_PACKAGE_MANAGER -Rns --noconfirm $@ 2> /dev/null || true
    fi
}

cross_system_package() {
    for_fedora="$1"
    for_arch="${2-$for_fedora}"

    if is_operating_system $FEDORA; then
        echo $for_fedora
    elif is_operating_system $ARCH; then
        echo $for_arch
    fi
}

warn_if_system_unsupported() {
    addendum="$1"

    if is_operating_system $FEDORA || is_operating_system $ARCH; then
        return
    elif ! test $addendum; then
        echo "Unsupported OS"
    else
        echo "Unsupported OS: $addendum"

        exit 1
    fi
}

setup_automatic_updates() {
    if is_operating_system $NIXOS; then
        return
    fi

    if is_operating_system $FEDORA; then
        configuration_file="/etc/dnf/automatic.conf"

        # TODO: Organise OS-specific packages better
        install_package dnf-automatic && \
            echo "[commands]" | sudo tee $configuration_file > /dev/null && \
            echo "apply_updates=True" | sudo tee $configuration_file > /dev/null && \
            sudo systemctl enable --now dnf-automatic.timer
    elif is_operating_system $ARCH; then
        curl -fsSLo /tmp/automatic-updates.service https://raw.githubusercontent.com/cyrus01337/dotfiles-but-better/refs/heads/main/.config/arch/automatic-updates.service && \
            sudo systemctl enable /tmp/automatic-updates.service
    fi
}

setup_github_signing_key() {
    PRIVATE_KEY_FILE="$SSH_DIRECTORY/github_ed25519"
    PUBLIC_KEY_FILE="$SSH_DIRECTORY/github_ed25519.pub"

    if ! which bw &> /dev/null; then
        echo "Unable to setup signing key without Bitwarden CLI"

        exit 1
    elif test "$BITWARDEN_SESSION_TOKEN" = ""; then
        shell_command=""
        shell="$(echo $SHELL | grep -oP '(?<=/bin/)(.+)')"

        case $shell in
            bash | zsh)
                shell_command='export BITWARDEN_SESSION_TOKEN="$(bw login --raw)"'

                ;;
            fish)
                shell_command="set -x BITWARDEN_SESSION_TOKEN (bw login --raw)"

                ;;
            *)
                shell_command="I have no idea how to export a variable in $shell"

                ;;
        esac

        error_message="Unable to setup signing key without session token, run the following command:\n\n"
        error_message+="\t$shell_command\n\n"
        error_message+="Then run this script again using the BW_SESSION environment variable:\n\n"
        error_message+="\tenv BITWARDEN_SESSION_TOKEN=... <command>"

        echo -e $error_message

        exit 1
    fi

    if test ! -f $PRIVATE_KEY_FILE || test ! -f $PUBLIC_KEY_FILE; then
        bitwarden_payload="$(bw get item --session $BITWARDEN_SESSION_TOKEN 'GitHub Signing Key' | jq -r '.sshKey')"
        BITWARDEN_SESSION_TOKEN=""

        if test "$bitwarden_payload" = ""; then
            echo "Unable to find signing key"

            exit 1
        fi

        if test ! -f $PRIVATE_KEY_FILE; then
            install --mode 600 $PRIVATE_KEY_FILE && \
                echo $bitwarden_payload | jq -r ".privateKey" > $PRIVATE_KEY_FILE
        fi

        if test ! -f $PUBLIC_KEY_FILE; then
            install --mode 644 $PUBLIC_KEY_FILE && \
                echo $bitwarden_payload | jq -r ".publicKey" > $PUBLIC_KEY_FILE
        fi
        
        bitwarden_payload=""
    fi
}

setup_ssh() {
    SSH_CONFIGURATION_FILE="$SSH_DIRECTORY/config"

    if test ! -d $SSH_DIRECTORY; then
        mkdir --mode 700 $SSH_DIRECTORY
    fi

    if test ! -f $SSH_CONFIGURATION_FILE; then
        curl -L https://raw.githubusercontent.com/cyrus01337/dotfiles-but-better/refs/heads/main/.ssh/config -o $SSH_CONFIGURATION_FILE && \
            chmod 600 $SSH_CONFIGURATION_FILE
    fi

    setup_github_signing_key

    if ! ps aux | grep -e "^root.*sshd" &> /dev/null; then
        sudo systemctl enable --now --quiet sshd
    fi
}

prepare_operating_system() {
    packages=(
        "alacritty"
        "bat"
        "curl"
        "fastfetch"
        "fish"
        "flatpak"
        "fzf"
        "git"
        "git-delta"
        "htop"
        "jq"
        "obs-studio"
        "parallel"
        "ranger"
        "stow"
        "tmux"
        "unzip"
        $(cross_system_package "" "atuin")
        $(cross_system_package "" "bitwarden-cli")
        $(cross_system_package "gh" "github-cli")
        $(cross_system_package "lua" "lua51")
        $(cross_system_package "" "openssh")
        $(cross_system_package "open-vm-tools-desktop" "open-vm-tools")
        $(cross_system_package "" "otf-fantasque-sans-mono ttf-fantasque-sans-mono")
        $(cross_system_package "" "qq-bin")
        $(cross_system_package "" "tree-sitter-cli")
        $(cross_system_package "" "wget")
    )

    if is_operating_system $ARCH && ! which yay &> /dev/null; then
        setup_yay
    fi

    upgrade_system

    if $INSTALL_FLATPAKS; then
        packages+=($(cross_system_package "" "flatpak"))
    fi

    install_package ${packages[@]}
    remove_package $EXCLUDE_KDE_SOFTWARE

    setup_automatic_updates
    setup_ssh
}

install_bun() {
    export BUN_INSTALL="$HOME/.local/share/bun"

    if test -d $BUN_INSTALL || test -d "$HOME/.bun"; then
        return
    fi

    curl -fsSL https://bun.sh/install | bash
}

install_docker() {
    if which docker &> /dev/null; then
        return
    fi

    if is_operating_system $ARCH; then
        install_package docker docker-compose
    else
        sudo sh -c "$(curl -fsSL https://get.docker.com)"
    fi

    sudo usermod -aG docker $USER && \
        sudo systemctl enable --now --quiet docker.socket
}

install_fnm() {
    directory="$HOME/.local/share/fnm"
    default_major_node_version="22"
    export PATH="$PATH:$directory"

    if test -d $directory; then
        return
    fi

    curl -fsSL https://fnm.vercel.app/install | bash
    eval "$(fnm env --shell bash)"
    fnm install $default_major_node_version
}

install_go() {
    archive_path="$TEMPORARY_DIRECTORY/lazydocker.tar.gz"
    export GOPATH="$HOME/.local/share/go"

    if test -d /usr/local/go; then
        return
    fi

    export PATH="$PATH:/usr/local/go/bin"

    curl -Lo $archive_path https://go.dev/dl/go1.24.3.linux-amd64.tar.gz && \
        sudo tar -C /usr/local -xzf $archive_path
}

install_lazydocker() {
    if which lazydocker &> /dev/null; then
        return
    fi

    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
}

install_lazygit() {
    if which lazygit &> /dev/null; then
        return
    fi

    if is_operating_system $FEDORA; then
        sudo dnf copr enable -y atim/lazygit && \
            install_package lazygit
    elif is_operating_system $ARCH; then
        install_package lazygit
    fi
}

install_python_build_dependencies() {
    if is_operating_system $FEDORA; then
        install_package bzip2 bzip2-devel gcc gdbm-libs libffi-devel libnsl2 libuuid-devel make openssl-devel patch readline-devel sqlite sqlite-devel tk-devel xz-devel zlib-devel 2> /dev/null
    elif is_operating_system $ARCH; then
        install_package --needed base-devel openssl tk xz zlib
    fi
}

install_pyenv() {
    export PYENV_ROOT="$HOME/.local/share/pyenv"
    default_major_python_version="3.13"

    if test -d $PYENV_ROOT; then
        return
    fi

    export PATH="$PYENV_ROOT/bin:$PATH"

    install_python_build_dependencies
    curl -fsSL https://pyenv.run | bash

    eval "$(pyenv init - bash)" && \
        eval "$(pyenv virtualenv-init -)"
    pyenv install $default_major_python_version && \
        pyenv virtualenv $default_major_python_version home && \
        pyenv global home && \
        pyenv shell home
    pip install git+https://github.com/cyrus01337/sharenv.git#egg=sharenv uv
}

install_rust() {
    export CARGO_HOME="$HOME/.local/share/cargo"
    export RUSTUP_HOME="$HOME/.local/share/rustup"

    if test -d $CARGO_HOME || test -d $RUSTUP_HOME; then
        return
    fi

    curl https://sh.rustup.rs -fsS | sh -s -- -y && \
        source "$CARGO_HOME/env"
}

install_starship() {
    if which starship &> /dev/null; then
        return
    fi

    if is_operating_system $FEDORA; then
        sudo dnf copr enable -y atim/starship && \
            install_package starship
    elif is_operating_system $ARCH; then
        install_package starship
    fi
}

install_dotfiles() {
    root="$HOME/Projects/personal"
    directory="$root/dotfiles-but-better"

    if test -d $directory; then
        return
    fi

    shared_stow_ignore_file_kind="default"
    stow_ignore_file_location="$directory/.stow-local-ignore"

    mkdir -p $root && \
        git clone --recurse-submodules git@github.com:cyrus01337/dotfiles-but-better.git $directory

    if test ! -d $directory; then
        return
    fi

    if is_operating_system $NIXOS; then
        shared_stow_ignore_file_kind="nixos"
    elif is_operating_system $FEDORA; then
        shared_stow_ignore_file_kind="fedora"
    elif is_operating_system $ARCH; then
        shared_stow_ignore_file_kind="arch"
    fi

    cp "$directory/lib/default.stow-local-ignore" $stow_ignore_file_location && \
        cat "$directory/lib/${shared_stow_ignore_file_kind}.stow-local-ignore" >> $stow_ignore_file_location && \
        sort -f --sort=n .stow-local-ignore --output .stow-local-ignore && \
        rm "$HOME/.bashrc" && \
        stow -t $HOME -d $directory --adopt . && \
        rm -f $stow_ignore_file_location
}

install_neovim() {
    if which nvim &> /dev/null; then
        return
    fi

    if is_operating_system $FEDORA || is_operating_system $ARCH; then
        install_package luarocks neovim
    fi
}

prepare_operating_system

if $INSTALL_FLATPAKS; then
    flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
        flatpak install -y --noninteractive --user ${FLATPAK_SOFTWARE[@]} || true
fi

if ! is_operating_system $NIXOS; then
    install_bun && \
        install_docker && \
        install_fnm && \
        install_go && \
        install_lazydocker && \
        install_lazygit && \
        install_pyenv && \
        install_rust
    install_starship && \
        install_dotfiles && \
        install_neovim
fi

source $HOME/.bashrc
