#!/usr/bin/env fish
set ROKIT_DIRECTORY "$HOME/.rokit"

if test -d $ROKIT_DIRECTORY
    fish_add_path "$ROKIT_DIRECTORY/bin"
end
