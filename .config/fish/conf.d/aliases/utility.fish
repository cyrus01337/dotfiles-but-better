#!/usr/bin/env fish
set FISH_CONFIG_PATH "$__fish_config_dir/config.fish"

alias f='n $__fish_config_dir/ -c "nvim ." && . $FISH_CONFIG_PATH'
alias lsa="ls -a"
alias lsal="ls -al"
alias lsl="ls -l"
alias q="exit"
alias r="clear && . $FISH_CONFIG_PATH"
alias schmod="sudo chmod"
alias schown="sudo chown"
alias sshq="ssh -q"
alias scpq="scp &> /dev/null"
alias tree="tree -C"
