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

is_interactive_shell() {
    [[ $- == *"i"* ]]
}

in_i3() {
    ps -e | rg "i3"
}

if (
    is_interactive_shell &&
    which tmux &> /dev/null &&
    test ! $TMUX &&
    test ! ${BASH_EXECUTION_STRING} &&
    [[ $(in_i3) || ${SHLVL} == 1 ]] ||
    test $TERM_PROGRAM = "vscode"
); then
    exec tmux new-session -As main
fi
