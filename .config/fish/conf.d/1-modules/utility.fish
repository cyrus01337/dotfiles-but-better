#!/usr/bin/env fish
abbr c "clear"
abbr --set-cursor --position=anywhere jc "journalctl -u%"
abbr l "ls -al"
abbr --position=anywhere nuke "rm -rf"
abbr --position=anywhere nuke-all "rm -rf ./{*,.*}"
abbr --position=anywhere pr "| rg"
abbr q "exit"
abbr r "clear && source $__fish_config_dir/config.fish"
abbr --position=anywhere s "sudo"
abbr --position=anywhere sc "systemctl"
abbr scpq "scp &> /dev/null"
abbr se "sudoedit"
abbr sshq "ssh -q"
abbr tree "tree -C"

return 0
