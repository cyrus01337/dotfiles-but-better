#!/usr/bin/env fish
set -x PNPM_HOME "$HOME/.local/share/pnpm"

if test -d $PNPM_HOME
    fish_add_path $PNPM_HOME
end

return 0
