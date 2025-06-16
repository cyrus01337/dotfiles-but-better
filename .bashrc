export PYENV_ROOT="$HOME/.local/share/pyenv"
export PYENV_VIRTUALENV_DISABLE_PROMPT=true
export PARENT_TERM_PROGRAM="$TERM_PROGRAM"

if test -f /etc/bashrc; then
    source /etc/bashrc
fi

if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

export PATH

if test -d "$HOME/.bashrc.d"; then
    for rc in "$HOME/.bashrc.d/*"; do
        if test -f "$rc"; then
            source "$rc"
        fi
    done
fi

unset rc

alias l="ls -al"
alias q="exit"
alias r="source ~/.bashrc"

is_interactive_shell() {
    [[ $- == *"i"* ]]
}

in_i3() {
    ps -e | rg "i3"
}

if test -d $PYENV_ROOT; then
    export PATH="$PYENV_ROOT/bin:$PATH"

    eval "$(pyenv init - bash)" &> /dev/null
    eval "$(pyenv virtualenv-init -)" &> /dev/null
fi

eval "$(sharenv --shell bash)"

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
