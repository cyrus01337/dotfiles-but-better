export CARGO_HOME="$HOME/.local/share/cargo"
export PYENV_ROOT="$HOME/.local/share/pyenv"
export PYENV_VIRTUALENV_DISABLE_PROMPT=true

if test -d $PYENV_ROOT; then
    export PATH="$PYENV_ROOT/bin:$PATH"

    eval "$(pyenv init - bash)" &> /dev/null
    eval "$(pyenv virtualenv-init -)" &> /dev/null
fi

eval "$(sharenv)"

if test -f "$HOME/.bashrc"; then
    source ~/.bashrc
fi

if test -f "$CARGO_HOME/env"; then
    source "$CARGO_HOME/env"
fi
