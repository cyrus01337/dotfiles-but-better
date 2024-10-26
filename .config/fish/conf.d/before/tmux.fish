#!/usr/bin/env fish
if which tmux &> /dev/null; and not [ $TMUX ]
    exec tmux new-session -As main
end
