#!/usr/bin/env fish
function p_detect
    if command -q yay; or command -q pacman
        return 0
    end

    return 127
end

function p_setup
    if command -q yay
        abbr p "yay"
        abbr pi "yay -S --needed --noconfirm"
        abbr pq "yay -Qi"
        abbr --set-cursor pri "set target %; yay -Rns --noconfirm \$target && yay -S --needed --noconfirm \$target"
        abbr prm "yay -Rns --noconfirm"
        abbr psr "yay -Ss"
        abbr psu "yay -Syu --noconfirm"
        abbr pu "yay -S --needed --noconfirm"
    else if command -q pacman
        abbr p "sudo pacman"
        abbr pi "sudo pacman -S --needed --noconfirm"
        abbr pq "sudo pacman -Qi"
        abbr --set-cursor pri "set target %; sudo pacman -Rns --noconfirm \$target && sudo pacman -S --needed --noconfirm \$target"
        abbr prm "sudo pacman -Rns --noconfirm"
        abbr psr "pacman -Ss"
        abbr psu "sudo pacman -Syu --noconfirm"
        abbr pu "sudo pacman -S --needed --noconfirm"
    else
        return 127
    end

    return 0
end

function p_teardown
    abbr --erase p pi pq pri prm psr psu pu

    return 0
end

