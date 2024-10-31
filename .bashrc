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

alias lsal="ls -al"
alias r="source ~/.bashrc"

if which shell &> /dev/null; then
    shell

    cached_status=$?

    if [[ $cached_status != 0 ]]; then
        echo "Shell exited with status code $cached_status"
    fi
fi
