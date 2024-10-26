#!/usr/bin/env fish
set FNM_DIRECTORY "$HOME/.local/share/fnm"

if [ -d "$FNM_DIRECTORY" ]
    fish_add_path "$FNM_DIRECTORY"

    fnm env --use-on-cd --shell fish | source
end
