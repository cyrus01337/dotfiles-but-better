#!/usr/bin/env fish
if command -q flatpak &> /dev/null
    fish_add_path "/var/lib/flatpak/exports/bin"

    abbr f "flatpak"
    abbr fi "flatpak install -y"
    abbr fu "flatpak uninstall -y"
    abbr --set-cursor fp "flatpak uninstall -y % && flatpak uninstall -y --unused"
    abbr fup "flatpak update -y"
end

return 0
