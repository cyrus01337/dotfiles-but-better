#!/usr/bin/env fish
function p_detect
    if command -q yay
        return 0
    end

    return 127
end

function p_setup
    abbr p "yay"
    abbr pi "sudo yay -S --needed --noconfirm"
    abbr prm "sudo yay -Rns --noconfirm"
    abbr pq "yay -Qi"
    abbr psr "yay -Ss"
    abbr psu "sudo yay -Syu --noconfirm"
    abbr pu "sudo yay -S --needed --noconfirm"

    return 0
end

function p_teardown
    abbr --erase p pi prm psr psu pu

    return 0
end

