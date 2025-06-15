export XDG_CONFIG_DIRS="/etc/xdg"
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$XDG_DATA_HOME/flatpak/exports/share:/usr/share/ubuntu:/usr/share/gnome:/usr/local/share/:/usr/share/"

export PYENV_ROOT="$HOME/.local/share/pyenv"
export PYENV_VIRTUALENV_DISABLE_PROMPT=true

HOME_MANAGER_SCRIPT="/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"

if test -d $PYENV_ROOT; then
    export PATH="$PYENV_ROOT/bin:$PATH"

    eval "$(pyenv init - bash)" &> /dev/null
    eval "$(pyenv virtualenv-init -)" &> /dev/null
fi

if test -f $HOME_MANAGER_SCRIPT; then
    source $HOME_MANAGER_SCRIPT
fi
