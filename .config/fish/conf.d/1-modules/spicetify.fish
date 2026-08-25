#!/usr/bin/env fish
set SPICETIFY_PATH "$HOME/.spicetify"

if test -d $SPICETIFY_PATH; or command -q spicetify &>/dev/null
    fish_add_path $SPICETIFY_PATH

    function update-spicetify
        pkill spotify
        spicetify restore backup apply
    end
end

return 0
