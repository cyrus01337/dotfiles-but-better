#!/usr/bin/env fish
bind ctrl-backspace "backward-kill-word"
bind \e\[1\;5H "beginning-of-buffer"
bind \e\[1\;5F "end-of-buffer"
bind -M insert tab '
    if commandline --search-field >/dev/null
        commandline -f complete
    else
        commandline -f complete-and-search
    end
'

return 0
