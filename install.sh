#!/usr/bin/env bash
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

log() {
    echo -e "\n\x1b[33;1m$@...\x1b[0m\n" >&2
}

log_red() {
    echo -e "\n\x1b[31;1m$@...\x1b[0m\n" >&2
}

upgrade_system() {
    log "Upgrading system"

    if is_operating_system $FEDORA; then
        sudo dnf upgrade -y
    elif is_operating_system $ARCH; then
        $ARCH_PACKAGE_MANAGER -Syu --needed --noconfirm
    fi
}

setup_yay() {
    log "Setting up Yay"

    git clone https://aur.archlinux.org/yay.git /tmp/yay && \
        env GOFLAGS=-buildvcs=false makepkg -cfirsC --needed --noconfirm --dir /tmp/yay && \
        yay --cleanafter --removemake --save --answerclean all --answerdiff none --answeredit none --answerupgrade all
}

install_package() {
    log "Installing $@"

    if is_operating_system $FEDORA; then
        sudo dnf install -y $@
    elif is_operating_system $ARCH; then
        $ARCH_PACKAGE_MANAGER -S --needed --noconfirm $@
    fi
}

remove_package() {
    log "Removing $@"

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
        log "$addendum is supported"

        return
    else
        if ! test $addendum; then
            log_red "Unsupported OS"
        else
            log_red "Unsupported OS: $addendum"
        fi

        exit 1
    fi
}

install_mise() {
    curl https://mise.run | sh
    eval "$(~/.local/bin/mise activate $(basename $SHELL))"
}

install_packages_with_mise() {
    export BUN_INSTALL="$HOME/.local/share/bun"
    export CARGO_HOME="$HOME/.local/share/cargo"
    export GNUPGHOME="$HOME/.gnupg"
    export GOPATH="$HOME/.local/share/go"
    export RUSTUP_HOME="$HOME/.local/share/rustup"

    mise use --global \
        atuin \
        bat \
        bun \
        delta \
        docker-cli \
        docker-compose \
        fastfetch \
        fd \
        fzf \
        gh \
        go \
        jq \
        lazydocker \
        lazygit \
        lua@5.1 \
        neovim \
        node@22 \
        python@3.13 \
        rust \
        starship \
        tmux \
        uv
}

install_qq() {
    if is_operating_system $ARCH; then
        install_package qq-bin
    else
        tarball_url=$(
            curl https://api.github.com/repos/JFryy/qq/releases/latest \
                | jq --raw-output '.assets[] | select(.name | endswith("linux-amd64.tar.gz")) | .browser_download_url'
        )

        curl -fsSL $tarball_url -o /tmp/qq.tar.gz \
            && sudo tar -C /usr/local/bin -xzf /tmp/qq.tar.gz
    fi
}

install_bluetooth_autoconnect() {
    if is_operating_system $ARCH; then
        install_package bluetooth-autoconnect
    else
        directory="/tmp/bluetooth-autoconnect"

        git clone https://github.com/jrouleau/bluetooth-autoconnect.git $directory \
            && sudo mv "$directory/bluetooth-autoconnect" /usr/local/bin/ \
            && sudo cp "$directory/bluetooth-autoconnect.service" /etc/systemd/system/ \
            && sudo cp "$directory/bluetooth-autoconnect.service" /usr/lib/systemd/system/
    fi

    sudo systemctl enable --now bluetooth-autoconnect
}

setup_automatic_updates() {
    log "Setting up automatic updates"

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

# TODO: Simplify via `basename`
get_shell() {
    echo $(basename $SHELL)
}

setup_github_signing_key() {
    PRIVATE_KEY_FILE="$SSH_DIRECTORY/github_ed25519"
    PUBLIC_KEY_FILE="$SSH_DIRECTORY/github_ed25519.pub"

    log "Setting up GitHub signing key"

    if ! which bw &> /dev/null; then
        log_red "Unable to setup signing key without Bitwarden CLI"

        exit 1
    elif test "$BITWARDEN_SESSION_TOKEN" = ""; then
        shell_command=""
        running_shell="$(get_shell)"

        case $running_shell in
            bash | zsh)
                shell_command='export BITWARDEN_SESSION_TOKEN="$(bw login --raw)"'

                ;;
            fish)
                shell_command="set -x BITWARDEN_SESSION_TOKEN (bw login --raw)"

                ;;
            *)
                shell_command="I have no idea how to export a variable in $running_shell"

                ;;
        esac

        error_message="Unable to setup signing key without session token, run the following command:\n\n"
        error_message+="\t$shell_command\n\n"
        error_message+="Then run this script again using the BITWARDEN_SESSION_TOKEN environment variable:\n\n"
        error_message+="\tenv BITWARDEN_SESSION_TOKEN=... <command>"

        log $error_message

        exit 1
    fi

    if test ! -f $PRIVATE_KEY_FILE || test ! -f $PUBLIC_KEY_FILE; then
        bitwarden_payload="$(bw get item --session $BITWARDEN_SESSION_TOKEN 'GitHub Signing Key' | jq -r '.sshKey')"

        if test "$bitwarden_payload" = ""; then
            log_red "Unable to find signing key"

            exit 1
        fi

        if test ! -f $PRIVATE_KEY_FILE; then
            install --mode 600 <(echo $bitwarden_payload | jq -r ".privateKey") $PRIVATE_KEY_FILE
        fi

        if test ! -f $PUBLIC_KEY_FILE; then
            install --mode 644 <(echo $bitwarden_payload | jq -r ".publicKey") $PUBLIC_KEY_FILE
        fi

        bitwarden_payload=""
    fi

    curl --silent https://api.github.com/meta | jq --raw-output '"github.com "+.ssh_keys[]' >> ~/.ssh/known_hosts
}

setup_ssh() {
    SSH_CONFIGURATION_FILE="$SSH_DIRECTORY/config"

    log "Setting up SSH"

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

setup_sharenv() {
    uv pip install --system git+https://github.com/cyrus01337/sharenv.git#egg=sharenv
}

prepare_operating_system() {
    packages=(
        "alacritty"
        "curl"
        "fish"
        "flatpak"
        "git"
        "htop"
        "obs-studio"
        "parallel"
        "ranger"
        "stow"
        "unzip"
        $(cross_system_package "bw-cli" "bitwarden-cli")
        $(cross_system_package "" "openssh")
        $(cross_system_package "open-vm-tools-desktop" "open-vm-tools")
        $(cross_system_package "" "otf-fantasque-sans-mono ttf-fantasque-sans-mono")
        $(cross_system_package "" "wget")
        $(cross_system_package "ydotool" "ydotool-git")
    )

    log "Preparing operating system"

    if is_operating_system $ARCH && ! which yay &> /dev/null; then
        setup_yay
    fi

    upgrade_system

    if $INSTALL_FLATPAKS; then
        packages+=($(cross_system_package "" "flatpak"))
    fi

    install_package ${packages[@]}
    install_mise
    install_packages_with_mise
    install_qq
    install_bluetooth_autoconnect
    remove_package $EXCLUDE_KDE_SOFTWARE

    setup_automatic_updates
    setup_ssh
    setup_sharenv
}

install_dotfiles() {
    root="$HOME/Projects/personal"
    directory="$root/dotfiles-but-better"

    if test -d $directory; then
        return
    fi

    log "Installing dotfiles"

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
        sort -f --sort=n $stow_ignore_file_location --output $stow_ignore_file_location && \
        stow -t $HOME -d $directory --adopt . && \
        rm -f $stow_ignore_file_location && \
        git -C $directory checkout -f .
}

prepare_operating_system

if $INSTALL_FLATPAKS; then
    log "Installing Flatpaks"

    flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
        flatpak install -y --noninteractive --user ${FLATPAK_SOFTWARE[@]} || true
fi

if ! is_operating_system $NIXOS; then
    install_dotfiles

    running_shell="$(get_shell)"

    if test ! "$running_shell" = "bash"; then
        log "Changing shell to Bash"

        sudo chsh -s /usr/bin/bash $USER
    fi
fi

source $HOME/.bashrc
