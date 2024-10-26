#!/usr/bin/env fish
set SPICETIFY_PATH "$HOME/.spicetify"

if [ -d $SPICETIFY_PATH ]
    fish_add_path "$SPICETIFY_PATH"
end

return 0
