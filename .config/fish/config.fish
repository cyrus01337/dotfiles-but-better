#!/usr/bin/env fish
set fish_greeting

fish_add_path "$HOME/bin" "$HOME/bin/custom" "/snap/bin" "$HOME/.local/bin" "/opt" "$HOME/.spicetify"
fish_config theme choose "Dracula Official"

eval "$(env PYENV_VERSION=home sharenv)"
