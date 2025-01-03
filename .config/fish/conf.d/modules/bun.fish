#!/usr/bin/env fish
if [ -s "$HOME/.bun/bin/bun" ]
    set -x BUN_INSTALL "$HOME/.bun"

    fish_add_path "$BUN_INSTALL/bin"
end

return 0
