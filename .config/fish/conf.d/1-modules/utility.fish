#!/usr/bin/env fish
abbr c "clear"
abbr --position=anywhere jc "journalctl"
abbr l "ls -al"
abbr nuke "rm -rf ./{*,.*}"
abbr q "exit"
abbr r "clear && source $__fish_config_dir/config.fish"
abbr --position=anywhere s "sudo"
abbr --position=anywhere sc "systemctl"
abbr scpq "scp &> /dev/null"
abbr se "sudoedit"
abbr sshq "ssh -q"
abbr tree "tree -C"

return 0
