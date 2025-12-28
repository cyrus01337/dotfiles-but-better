#!/usr/bin/env fish
if command -q atuin &> /dev/null
    atuin init fish | sed 's/-k up/up/' | source
end
