#!/usr/bin/env fish
if command -q flatpak
    fish_add_path "/var/lib/flatpak/exports/bin"
end

return 0
