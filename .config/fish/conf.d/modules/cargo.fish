#!/usr/bin/env fish
set -x CARGO_HOME "$HOME/.local/share/cargo"
set -x RUSTUP_HOME="$HOME/.local/share/rustup"
set CARGO_ENVIRONMENT_PATH "$CARGO_HOME/env.fish"

if test -f $CARGO_ENVIRONMENT_PATH
    source $CARGO_ENVIRONMENT_PATH
end

return 0
