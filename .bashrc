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
export LC_CTYPE="en_GB.UTF-8"
export LANGUAGE="en_GB:en"

if [[
    $- == *"i"* &&
    $(which tmux) &&
    ! $TMUX &&
    -z ${BASH_EXECUTION_STRING} &&
    ${SHLVL} == 1
]]; then
    exec tmux new-session -As main
fi
