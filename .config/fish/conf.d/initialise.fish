#!/usr/bin/env fish
# set -U DISABLE_COMMAND_TIMER true
set -U DOTFILES_DIRECTORY "$HOME/Projects/personal/dotfiles-but-better"
set CUSTOM_MODULES_DIRECTORY "$__fish_config_dir/conf.d/1-modules"

if set --query TMUX_POPUP
    source $CUSTOM_MODULES_DIRECTORY/change-fzf.fish
    source $CUSTOM_MODULES_DIRECTORY/edit-fzf.fish
    source $CUSTOM_MODULES_DIRECTORY/projects.fish
else
    for script in $__fish_config_dir/conf.d/*/*{,/*}.fish
        source $script
    end

    if command -q systemd-analyze &>/dev/null; and test "$TMUX_PANE" = "%0"
        systemd-analyze
    end
end
