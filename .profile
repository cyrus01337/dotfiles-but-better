export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_DIRS="/etc/xdg"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:/usr/share/ubuntu:/usr/share/gnome:/usr/local/share/:/usr/share/"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_RUNTIME_DIR="$HOME/.local/runtime"
export XDG_STATE_HOME="$HOME/.local/state"

export LANG="en_GB.UTF-8"
export LC_ALL="$LANG"
export LC_CTYPE="$LANG"
export LANGUAGE="en_GB:en"

export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export INPUTRC="$HOME/.inputrc"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"

export EDITOR="vi"
export VISUAL="nvim"

HOME_MANAGER_SCRIPT="/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"

if test -f $HOME_MANAGER_SCRIPT; then
    source $HOME_MANAGER_SCRIPT
fi
