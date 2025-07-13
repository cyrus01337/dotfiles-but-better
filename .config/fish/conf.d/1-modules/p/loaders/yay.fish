#!/usr/bin/env fish
function p_detect
    if command -q yay
        return 0
    end

    return 127
end

function p_setup
    abbr p "yay"
    abbr pi "yay -S --needed --noconfirm"
    abbr pq "yay -Qi"
    abbr prm "yay -Rns --noconfirm"
    abbr psr "yay -Ss"
    abbr psu "yay -Syu --noconfirm"
    abbr pu "yay -S --needed --noconfirm"

    return 0
end

function p_teardown
    abbr --erase p pi prm psr psu pu

    return 0
end

