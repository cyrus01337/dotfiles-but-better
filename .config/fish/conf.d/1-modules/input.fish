#!/usr/bin/env fish
if command -q xset; and timeout 1s xset q &> /dev/null
    xset r rate 250 30
end
