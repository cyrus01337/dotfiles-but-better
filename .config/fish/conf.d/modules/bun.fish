#!/usr/bin/env fish
set -x BUN_INSTALL "$HOME/.local/share/bun"

if test -s $BUN_INSTALL
    fish_add_path "$BUN_INSTALL/bin"
end

return 0
