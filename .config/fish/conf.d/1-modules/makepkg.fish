#!/usr/bin/env fish
if command -q makepkg &> /dev/null
    abbr makepkg-but-stupid "makepkg -cfirsC --noconfirm"
end
