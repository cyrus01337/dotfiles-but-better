#!/usr/bin/env fish
set -x STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"

if which starship &> /dev/null
    starship init fish | source
end
