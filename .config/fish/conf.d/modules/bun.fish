#!/usr/bin/env fish
if [ -s "$HOME/.bun/_bun" ]
    set -x BUN_INSTALL "$HOME/.bun"
    fish_add_path "$BUN_INSTALL/bin"

    source "$HOME/.bun/_bun"
end

return 0
