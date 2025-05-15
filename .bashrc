if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

export PATH

if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi

unset rc

alias l="ls -al"
alias q="exit"
alias r="source ~/.bashrc"

export GNUPGHOME="$HOME/.local/gnupg"
export LANG="en_GB.UTF-8"
export LC_ALL="en_GB.UTF-8"
export LANGUAGE="en_GB:en"

AUTOSTART_SHELL=${AUTOSTART_SHELL:-true}
in_interactive_shell=false

function _can_autostart_shell() {
    [[ $AUTOSTART_SHELL = true || $AUTOSTART_SHELL = 1 ]]
}

if [[ $- == *i* ]]; then
    in_interactive_shell=true
fi

if _can_autostart_shell && [[ $in_interactive_shell == true && ! -f /.dockerenv ]]; then
    if ! which shell &> /dev/null; then
        eval "$(curl -fsSL https://github.com/cyrus01337/dotfiles-but-better/raw/refs/heads/main/bin/shell)"
    else
        shell
    fi

    cached_status=$?

    if [[ $cached_status != 0 ]]; then
        echo "Shell exited with status code $cached_status"
    fi
fi
