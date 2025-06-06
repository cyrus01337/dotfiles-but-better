#!/usr/bin/env fish
set -x HOMEBREW_NO_ENV_HINTS true
set HOMEBREW_DIRECTORY "/home/linuxbrew"

if command -q brew; and test -d $HOMEBREW_DIRECTORY
    eval "$($HOMEBREW_DIRECTORY/.linuxbrew/bin/brew shellenv)"
end

return 0
