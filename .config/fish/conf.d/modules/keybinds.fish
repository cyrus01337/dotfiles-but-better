#!/usr/bin/env fish
bind \e\[7\;5~ "backward-kill-word"
bind \e\[1\;5H "beginning-of-buffer"
bind \e\[1\;5F "end-of-buffer"
bind \cQ "exit"
bind \t "complete-and-search"

return 0
