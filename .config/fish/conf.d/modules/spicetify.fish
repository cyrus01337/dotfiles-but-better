#!/usr/bin/env fish
set SPICETIFY_PATH "$HOME/.spicetify"

if test -d $SPICETIFY_PATH
    fish_add_path $SPICETIFY_PATH

    function update-spicetify
        spicetify update
        spicetify backup apply
    end
end

return 0
