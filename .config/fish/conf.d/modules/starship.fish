#!/usr/bin/env fish
set -x STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"

if command -q starship
    starship init fish | source
end
