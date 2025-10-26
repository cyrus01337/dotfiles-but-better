#!/usr/bin/env fish
set BIN_PATH "$HOME/bin/external"

if test -f "$BIN_PATH/bin"
    fish_add_path $BIN_PATH
end

return 0
