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

export PARENT_TERM_PROGRAM="$TERM_PROGRAM"

if [[
    $- == *"i"* &&
    $(which tmux) &&
    ! $TMUX &&
    -z ${BASH_EXECUTION_STRING} &&
    ${SHLVL} == 1 ||
    $TERM_PROGRAM == "vscode"
]]; then
    exec tmux new-session -As main
fi
