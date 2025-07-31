#!/usr/bin/env fish
set fish_greeting
# set -U DISABLE_COMMAND_TIMER true

fish_add_path "$HOME/bin" "$HOME/bin/custom" "/snap/bin" "$HOME/.local/bin" "/opt" "$HOME/.spicetify"
fish_config theme choose "Dracula Official"

eval "$(sharenv)"
