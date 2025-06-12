#!/usr/bin/env fish
function p_detect
    if command -q pacman
        return 0
    end

    return 127
end

function p_setup
    alias p "pacman"
    alias pi "sudo pacman -S --needed --noconfirm"
    alias prm "sudo pacman -Rns --noconfirm"
    alias psr "pacman -Ss"
    alias psu "sudo pacman -Syu --noconfirm"
    alias pu "sudo pacman -S --needed --noconfirm"

    return 0
end

function p_teardown
    functions --erase p pi prm psr psu pu

    return 0
end

