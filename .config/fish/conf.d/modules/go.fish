#!/usr/bin/env fish
set -x GOPATH "$HOME/.local/share/go"

if which go &> /dev/null; or [ -d "$GOPATH/go" ]
    fish_add_path "/usr/local/go/bin" "$GOPATH/bin" "$HOME/.local/bin"
end
