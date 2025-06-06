#!/usr/bin/env fish
if command -q tmux; and not test $TMUX
    exec tmux new-session -As main
end
