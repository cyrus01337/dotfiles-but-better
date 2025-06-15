#!/usr/bin/env fish
function p_detect
    if command -q dnf
        return 0
    end

    return 127
end

function p_setup
    alias p "dnf"
    alias pce "sudo dnf copr enable -y"
    alias pcr "sudo dnf copr remove -y"
    alias pi "sudo dnf install -y"
    alias pinf "dnf info"
    alias prm "sudo dnf remove -y"
    alias psr "dnf search"
    alias psu "sudo dnf system-upgrade -y"
    alias pu "sudo dnf upgrade -y"
    alias pup "sudo dnf upgrade -y"

    return 0
end

function p_teardown
    functions --erase p pce pcr pi pinf prm psr psu pu pup

    return 0
end
