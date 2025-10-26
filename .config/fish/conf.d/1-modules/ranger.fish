#!/usr/bin/env fish
if command -q ranger &> /dev/null
    set -x RANGER_LOAD_DEFAULT_RC false

    abbr ra "ranger"
end

return 0
