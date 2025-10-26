#!/usr/bin/env fish
set HOMEBREW_DIRECTORY "/home/linuxbrew"

if command -q brew &> /dev/null; and test -d $HOMEBREW_DIRECTORY
    set -x HOMEBREW_NO_ENV_HINTS true

    eval "$($HOMEBREW_DIRECTORY/.linuxbrew/bin/brew shellenv)"
end

return 0
