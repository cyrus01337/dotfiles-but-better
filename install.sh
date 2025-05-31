#!/usr/bin/env bash
set -e

TEMPORARY_DIRECTORY="$(mktemp -d)"
OPERATING_SYSTEM="$(hostnamectl | grep 'Operating System')"
FLATPAK_SOFTWARE=("app.zen_browser.zen com.github.PintaProject.Pinta com.github.taiko2k.tauonmb com.github.wwmm.easyeffects com.interversehq.qView com.visualstudio.code org.flameshot.Flameshot org.onlyoffice.desktopeditors org.videolan.VLC")
EXCLUDE_KDE_SOFTWARE=("elisa gwenview khelpcenter kinfocenter konsole spectacle")
UNIVERSAL_PACKAGES=("alacritty curl fish flatpak git jq parallel stow tmux")

is_operating_system() {
    # Without double brackets the same line using "test" reports the wrong exit
    # code (for some reason), so here it is embraced as a sole inconsistency
    [[ $OPERATING_SYSTEM == *"$1"* ]]
}

upgrade_system() {
    if is_operating_system "Fedora"; then
        sudo dnf upgrade -y $@
    fi
}

install_package() {
    if is_operating_system "Fedora"; then
        sudo dnf install -y $@
    fi
}

remove_package() {
    if is_operating_system "Fedora"; then
        sudo dnf remove -y $@ 2> /dev/null
    fi
}

cross_system_package() {
    for_fedora="$1"

    if is_operating_system "Fedora"; then
        echo $for_fedora
    fi
}

warn_if_system_unsupported() {
    addendum="$1"

    if is_operating_system "Fedora"; then
        return
    elif ! test $addendum; then
        echo "Unsupported OS"
    else
        echo "Unsupported OS: $addendum"
    fi
}

setup_automatic_updates() {
    if is_operating_system "NixOS"; then
        return
    fi

    if is_operating_system "Fedora"; then
        configuration_file="/etc/dnf/automatic.conf"

        echo "[commands]" | sudo tee $configuration_file > /dev/null && \
            echo "apply_updates=True" | sudo tee $configuration_file > /dev/null && \
            sudo systemctl enable --now dnf-automatic.timer
    fi
}

prepare_operating_system() {
    upgrade_system
    install_package \
        $UNIVERSAL_PACKAGES \
        $(cross_system_package "bat") \
        $(cross_system_package "dnf-automatic") \
        $(cross_system_package "fastfetch") \
        $(cross_system_package "gh") \
        $(cross_system_package "git-delta") \
        $(cross_system_package "obs-studio") \
        $(cross_system_package "lua")
    remove_package $EXCLUDE_KDE_SOFTWARE

    setup_automatic_updates
}

install_bun() {
    export BUN_INSTALL="$HOME/.local/share/bun"

    if test -d "$HOME/.bun"; then
        return
    fi

    curl -fsSL https://bun.sh/install | bash

    sudo usermod -aG docker $USER && \
        sudo systemctl enable --now --quiet docker.service
}

install_docker() {
    if which docker &> /dev/null; then
        return
    fi

    sudo sh -c "$(curl -fsSL https://get.docker.com)"
}

install_fnm() {
    directory="$HOME/.local/share/fnm"
    default_major_node_version="3.13"
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

    curl -Lo $archive_path https://go.dev/dl/ && \
        tar -C /usr/local -xzf $archive_path
}

}

install_python_build_dependencies() {
    if is_operating_system "Fedora"; then
        sudo dnf install -y bzip2 bzip2-devel gcc gdbm-libs libffi-devel libnsl2 libuuid-devel make openssl-devel patch readline-devel sqlite sqlite-devel tk-devel xz-devel zlib-devel 2> /dev/null
    fi
}

install_pyenv() {
    export PYENV_ROOT="$HOME/local/share/pyenv"
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
    elif is_operating_system "Fedora"; then
        sudo dnf copr enable -y atim/starship && \
            sudo dnf install -y starship
    fi
}

install_dotfiles() {
    root="$HOME/Projects/personal"
    directory="$root/dotfiles-but-better"

    if test -d $directory; then
        return
    fi

    mkdir -p $root && \
        git clone --recurse-submodules git@github.com:cyrus01337/dotfiles-but-better.git $directory && \
        stow -t $HOME -d $directory --adopt .
}

install_font() {
    directory="$HOME/.local/share/fonts/FantasqueSansMono-NerdFont"

    if test -d $directory; then
        return
    fi

    archive_path="$TEMPORARY_DIRECTORY/font.zip"

    mkdir -p $directory && \
        curl -OL $archive_path https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FantasqueSansMono.tar.xz && \
        tar -C $directory -xf $archive_path
}

install_neovim() {
    if which nvim &> /dev/null; then
        return
    fi

    if is_operating_system "Fedora"; then
        install_package luarocks neovim
    fi
}

prepare_operating_system
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

rm -rf "$HOME/.bashrc"

if test -d /etc/nixos; then
    rm -rf "$HOME/.config/fish"
else
    install_bun && \
        install_docker && \
        install_fnm && \
        install_go && \
        install_pyenv && \
        install_rust
    install_starship && \
        install_dotfiles && \
        install_font && \
        install_neovim
fi

flatpak install -y $FLATPAK_SOFTWARE
source $HOME/.bashrc
