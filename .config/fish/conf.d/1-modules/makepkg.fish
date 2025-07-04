#!/usr/bin/env fish
if command -q makepkg
    abbr makepkg-but-stupid "makepkg -cfirsC --noconfirm"
end
