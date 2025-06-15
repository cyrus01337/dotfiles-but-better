#!/usr/bin/env fish
set APP_IMAGES_DIRECTORY "$HOME/Applications"

if test -d "$APP_IMAGES_DIRECTORY"
    fish_add_path $APP_IMAGES_DIRECTORY
end

return 0
