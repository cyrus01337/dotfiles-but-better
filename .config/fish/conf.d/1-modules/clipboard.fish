#!/usr/bin/env fish
if test $XDG_SESSION_TYPE = "x11"; and command -q xclip
    alias clip="xclip -selection clipboard"
else if test $XDG_SESSION_TYPE = "wayland"; and command -q wl-copy
    alias clip="wl-copy"
end

if command -q clip
    function copy-to-clipboard
        set target $argv[1]

        cat $target | clip
    end
end

return 0
