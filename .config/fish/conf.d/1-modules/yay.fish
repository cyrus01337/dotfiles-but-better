#!/usr/bin/env fish
if command -q yay
    abbr p "yay"
    abbr pi "yay -S --needed --noconfirm"
    abbr prm "yay -Rns --noconfirm"
    abbr psr "yay -Ss"
    abbr psu "yay -Syu --noconfirm"
    abbr pu "yay -S --needed --noconfirm"
end
