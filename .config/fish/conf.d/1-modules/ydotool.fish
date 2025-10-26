#!/usr/bin/fish
if command -q ydotool &> /dev/null
    set -x YDOTOOL_SOCKET "/tmp/.ydotool_socket"
end
