#!/usr/bin/env fish
if command -q luarocks
    fish_add_path "$HOME/.luarocks/bin"
end

return 0
