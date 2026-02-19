#!/usr/bin/env fish
if command -q flatpak &> /dev/null
    fish_add_path "/var/lib/flatpak/exports/bin"

    abbr f "flatpak"
    abbr fi "flatpak install -y"
    abbr fup "flatpak update -y && flatpak uninstall -y --unused"
    abbr --set-cursor fu "flatpak uninstall -y % && flatpak uninstall -y --unused"
end

return 0
