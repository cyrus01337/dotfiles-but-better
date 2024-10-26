#!/usr/bin/env fish
set -x HOMEBREW_NO_ENV_HINTS true
set HOMEBREW_DIRECTORY "/home/linuxbrew"

if [ -d $HOMEBREW_DIRECTORY ]; and which brew &> /dev/null
    eval "$($HOMEBREW_DIRECTORY/.linuxbrew/bin/brew shellenv)"
end
