#!/usr/bin/env fish
set FISH_CONFIGURATION_PATH "$__fish_config_dir/config.fish"
set TMUX_CONFIGURATION_PATH "$HOME/.config/tmux/tmux.conf"

alias f='n $__fish_config_dir/ -c "nvim ." && . $FISH_CONFIGURATION_PATH'
alias lsa="ls -a"
alias lsal="ls -al"
alias lsl="ls -l"
alias q="exit"
alias r="clear && . $FISH_CONFIG_PATH"
alias schmod="sudo chmod"
alias schown="sudo chown"
alias sshq="ssh -q"
alias scpq="scp &> /dev/null"
alias t='n $TMUX_CONFIGURATION_PATH && tmux source $TMUX_CONFIGURATION_PATH'
alias tree="tree -C"
