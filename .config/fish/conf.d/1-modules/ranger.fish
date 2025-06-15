#!/usr/bin/env fish
set -x RANGER_LOAD_DEFAULT_RC false

if command -q ranger
    alias ra="ranger"
end

return 0
