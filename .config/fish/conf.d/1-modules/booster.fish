#!/usr/bin/env fish
if command -q booster &> /dev/null
    abbr reg "sudo /usr/lib/booster/regenerate_images"
end
