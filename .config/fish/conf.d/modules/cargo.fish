#!/usr/bin/env fish
set CARGO_ENVIRONMENT_PATH "$HOME/.cargo/env.fish"

if [ -f $CARGO_ENVIRONMENT_PATH ]
    source $CARGO_ENVIRONMENT_PATH
end

return 0
