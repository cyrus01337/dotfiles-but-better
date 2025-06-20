#!/usr/bin/env fish
function p_detect
    if command -q dnf
        return 0
    end

    return 127
end

function p_setup
    abbr p "dnf"
    abbr pce "sudo dnf copr enable -y"
    abbr pcr "sudo dnf copr remove -y"
    abbr pi "sudo dnf install -y"
    abbr pinf "dnf info"
    abbr prm "sudo dnf remove -y"
    abbr psr "dnf search"
    abbr psu "sudo dnf system-upgrade -y"
    abbr pu "sudo dnf upgrade -y"
    abbr pup "sudo dnf upgrade -y"

    return 0
end

function p_teardown
    functions --erase p pce pcr pi pinf prm psr psu pu pup

    return 0
end
