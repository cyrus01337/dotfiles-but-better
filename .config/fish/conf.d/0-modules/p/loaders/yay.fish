#!/usr/bin/env fish
function p_detect
    if command -q yay
        return 0
    end

    return 127
end

function p_setup
    alias p "yay"
    alias pi "sudo yay -S --needed --noconfirm"
    alias prm "sudo yay -Rns --noconfirm"
    alias psr "yay -Ss"
    alias psu "sudo yay -Syu --noconfirm"
    alias pu "sudo yay -S --needed --noconfirm"

    return 0
end

function p_teardown
    functions --erase p pi prm psr psu pu

    return 0
end

