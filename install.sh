#!/usr/bin/env bash
set -e

TEMPORARY_DIRECTORY="$(mktemp -d)"
OPERATING_SYSTEM="$(hostnamectl | grep 'Operating System')"
FEDORA="Fedora"
ARCH="Arch"
NIXOS="NixOS"
FLATPAK_SOFTWARE=("app.zen_browser.zen com.github.PintaProject.Pinta com.github.taiko2k.tauonmb com.github.wwmm.easyeffects com.interversehq.qView com.visualstudio.code org.flameshot.Flameshot org.onlyoffice.desktopeditors org.videolan.VLC com.github.tchx84.Flatseal")
EXCLUDE_KDE_SOFTWARE=("elisa gwenview khelpcenter kinfocenter konsole spectacle")

is_operating_system() {
    # Without double brackets the same line using "test" reports the wrong exit
    # code (for some reason), so here it is embraced as a sole inconsistency
    [[ $OPERATING_SYSTEM == *"$1"* ]]
}

upgrade_system() {
    if is_operating_system $FEDORA; then
        sudo dnf upgrade -y
    elif is_operating_system $ARCH; then
        sudo pacman -Syu --needed --noconfirm
    fi
}

install_package() {
    if is_operating_system $FEDORA; then
        sudo dnf install -y $@
    elif is_operating_system $ARCH; then
        sudo pacman -S --needed --noconfirm $@
    fi
}

remove_package() {
    if is_operating_system $FEDORA; then
        sudo dnf remove -y $@ 2> /dev/null
    elif is_operating_system $ARCH; then    
        sudo pacman -Rns --noconfirm $@ 2> /dev/null || true
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
    fi
}

setup_automatic_updates() {
    if is_operating_system $NIXOS; then
        return
    fi

    if is_operating_system $FEDORA; then
        configuration_file="/etc/dnf/automatic.conf"

        install_package "dnf-automatic" && \
            echo "[commands]" | sudo tee $configuration_file > /dev/null && \
            echo "apply_updates=True" | sudo tee $configuration_file > /dev/null && \
            sudo systemctl enable --now dnf-automatic.timer
    elif is_operating_system $ARCH; then
        curl -fsSLo /tmp/automatic-updates.service https://raw.githubusercontent.com/cyrus01337/dotfiles-but-better/refs/heads/main/.config/arch/automatic-updates.service && \
            sudo systemctl enable /tmp/automatic-updates.service
    fi
}

setup_ssh() {
    sudo systemctl enable --now --quiet sshd
}

prepare_operating_system() {
    upgrade_system
    install_package \
        alacritty \
        bat \
        curl \
        fastfetch \
        fish \
        flatpak \
        fzf \
        git \
        git-delta \
        jq \
        lua \
        obs-studio \
        parallel \
        ranger \
        stow \
        tmux \
        unzip \
        $(cross_system_package "gh" "github-cli") \
        $(cross_system_package "" "openssh")

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

    stow_ignore_file_kind="default"
    stow_ignore_file_location="$directory/.stow-local-ignore"

    mkdir -p $root && \
        git clone --recurse-submodules git@github.com:cyrus01337/dotfiles-but-better.git $directory

    if is_operating_system $NIXOS; then
        stow_ignore_file_kind="nixos"
    fi

    cp "$directory/lib/$stow_ignore_file_kind.stow-local-ignore" $stow_ignore_file_location && \
        curl -Lo .ssh/config https://raw.githubusercontent.com/cyrus01337/dotfiles-but-better/refs/heads/main/.ssh/config && \
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
flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
    flatpak install -y --user $FLATPAK_SOFTWARE

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

flatpak install -y $FLATPAK_SOFTWARE
source $HOME/.bashrc
