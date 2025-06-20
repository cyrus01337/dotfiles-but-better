#!/usr/bin/env fish
set -x RANGER_LOAD_DEFAULT_RC false

if command -q ranger
    abbr ra "ranger"
end

return 0
