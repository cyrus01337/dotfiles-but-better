#!/usr/bin/env fish
set -x GOPATH "$HOME/.local/go"

if command -q go; or test -d "$GOPATH/go"
    fish_add_path "/usr/local/go/bin" "$GOPATH/bin" "$HOME/.local/bin"
end

return 0
