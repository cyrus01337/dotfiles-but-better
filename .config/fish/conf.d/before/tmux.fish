#!/usr/bin/env fish
if command -q tmux; and not [ $TMUX ]
    exec tmux new-session -As main
end
