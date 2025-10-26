#!/usr/bin/env fish
# set -U DISABLE_COMMAND_TIMER true
set -U DOTFILES_DIRECTORY "$HOME/Projects/personal/dotfiles-but-better"

for script in $__fish_config_dir/conf.d/*/*{,/*}.fish
    source $script
end

if command -q systemd-analyze &> /dev/null; and not set -q INITIALISED
    systemd-analyze
end

set INITIALISED true
