#!/usr/bin/env fish
set FISH_CONFIG_PATH "$__fish_config_dir/config.fish"

alias d="edit $HOME/Projects/personal/dotfiles"
alias f="edit $HOME/.config/fish"
alias lsa="ls -a"
alias lsal="ls -al"
alias lsl="ls -l"
alias q="exit"
alias n="edit $HOME/.config/nvim"
alias r="clear && . $FISH_CONFIG_PATH"
alias sshq="ssh -q"
alias scpq="scp &> /dev/null"
alias tree="tree -C"
