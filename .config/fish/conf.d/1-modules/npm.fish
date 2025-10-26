#!/usr/bin/env fish
if command -q npm &> /dev/null
    set -x NPM_CONFIG_USERCONFIG "$HOME/.config/npm/npmrc"
end

return 0
