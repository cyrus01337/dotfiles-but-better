#!/usr/bin/env fish
if which flatpak &> /dev/null
    fish_add_path "/var/lib/flatpak/exports/bin"
end

return 0
