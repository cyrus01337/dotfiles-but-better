#!/usr/bin/env fish
if command -q flatpak &> /dev/null
    fish_add_path "/var/lib/flatpak/exports/bin"

    abbr f "flatpak"
    abbr fi "flatpak install -y"
    abbr fu "flatpak uninstall -y"
    abbr fup "flatpak update -y"
    abbr --set-cursor fp "set target \"%\"; flatpak uninstall -y $target && flatpak uninstall -y --unused $target"
end

return 0
