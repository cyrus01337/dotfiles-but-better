#!/usr/bin/env fish
abbr c "clear"
abbr l "ls -al"
abbr nuke "rm -rf ./{*,.*}"
abbr q "exit"
abbr r "clear && source $__fish_config_dir/config.fish"
abbr sshq "ssh -q"
abbr scpq "scp &> /dev/null"
abbr tree "tree -C"

return 0
