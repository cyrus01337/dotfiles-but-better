#!/usr/bin/env fish
if command -q luarocks &> /dev/null
    fish_add_path "$HOME/.luarocks/bin"
end

return 0
