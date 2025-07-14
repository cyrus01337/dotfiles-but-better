#!/usr/bin/env fish
set SWAY_PROCESS_ID (pidof sway)

if test $SWAY_PROCESS_ID
    set -x SWAYSOCK "$XDG_RUNTIME_DIR/sway-ipc.$(id -u $USER).$SWAY_PROCESS_ID.sock"
end
