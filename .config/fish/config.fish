#!/usr/bin/env fish
set -x EDITOR "vi"
set -x GOPATH "$HOME/.local/go"
set -x GNUPGHOME "$HOME/.local/gnupg"
set -x INPUTRC "$HOME/.inputrc"
set -gx LANG "en_GB.UTF-8"
set -gx LANGUAGE "en_GB:en"
set -gx LC_ALL "en_GB.UTF-8"
set -gx LC_CTYPE "en_GB.UTF-8"
set -x PASSWORD_STORE_DIR "$HOME/.local/password-store"
set -x VISUAL "vi"
set -x XDG_CACHE_HOME "$HOME/.cache"
set -x XDG_CONFIG_HOME "$HOME/.config"
set -Ux XDG_DATA_DIRS "/var/lib/flatpak/exports/share" "$HOME/.local/share/flatpak/exports/share" "/usr/share/ubuntu" "/usr/share/gnome" "/usr/local/share/" "/usr/share/"
set -x XDG_DATA_HOME "$HOME/.local/share"

set fish_greeting

fish_add_path "$HOME/bin" "$HOME/bin/custom" "/usr/local/go/bin" "/snap/bin" "$HOME/.local/bin" "/opt"
fish_config theme choose "Dracula Official"
