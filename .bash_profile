export CARGO_HOME="$HOME/.local/share/cargo"

if test -f "$HOME/.bashrc"; then
    source ~/.bashrc
fi

if test -f "$CARGO_HOME/env"; then
    source "$CARGO_HOME/env"
fi
