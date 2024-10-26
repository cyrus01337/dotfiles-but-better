#!/usr/bin/env fish
if [ "$XDG_SESSION_TYPE" = "x11" ]; and which xclip &> /dev/null
    alias clip="xclip -selection clipboard"
else if [ "$XDG_SESSION_TYPE" = "wayland" ]; and which wl-copy &> /dev/null
    alias clip="wl-copy"
end

if which clip &> /dev/null
    function copy-to-clipboard
        set target $argv[1]

        cat $target | clip
    end
end
