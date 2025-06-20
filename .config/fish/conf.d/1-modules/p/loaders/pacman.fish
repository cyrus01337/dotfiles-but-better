#!/usr/bin/env fish
function p_detect
    if command -q pacman
        return 0
    end

    return 127
end

function p_setup
    abbr p "sudo pacman"
    abbr pi "sudo pacman -S --needed --noconfirm"
    abbr prm "sudo pacman -Rns --noconfirm"
    abbr psr "pacman -Ss"
    abbr psu "sudo pacman -Syu --noconfirm"
    abbr pu "sudo pacman -S --needed --noconfirm"

    return 0
end

function p_teardown
    abbr --erase p pi prm psr psu pu

    return 0
end

