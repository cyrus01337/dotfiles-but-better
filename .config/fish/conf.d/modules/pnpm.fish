#!/usr/bin/env fish
set -x PNPM_HOME "$HOME/.local/share/pnpm"

if [ -d "$PNPM_HOME" ]
    fish_add_path $PNPM_HOME
end
