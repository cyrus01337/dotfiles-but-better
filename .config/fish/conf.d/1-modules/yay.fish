#!/usr/bin/env fish
if command -q yay
    abbr y "yay"
    abbr yi "yay -S --needed --noconfirm"
    abbr yq "yay -Qi"
    abbr yrm "yay -Rns --noconfirm"
    abbr ysr "yay -Ss"
    abbr ysu "yay -Syu --noconfirm"
    abbr yu "yay -S --needed --noconfirm"
end
