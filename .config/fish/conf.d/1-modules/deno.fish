#!/usr/bin/env deno
set -x DENO_INSTALL "$HOME/.local/share/deno"

if command -q deno &> /dev/null; or test -d $DENO_INSTALL
    fish_add_path "$DENO_INSTALL/bin"
end

return 0
