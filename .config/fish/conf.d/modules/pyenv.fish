#!/usr/bin/env fish
set -x PYENV_ROOT "$HOME/.local/pyenv"
set -x PYENV_VIRTUALENV_DISABLE_PROMPT true
set VENV_ACTIVATION_SCRIPT ".venv/bin/activate"

if [ -d "$PYENV_ROOT" ]
    fish_add_path "$PYENV_ROOT/bin"

    eval "$(pyenv init -)" &> /dev/null
    eval "$(pyenv virtualenv-init -)" &> /dev/null
else if [ -f $VENV_ACTIVATION_SCRIPT ]
    source $VENV_ACTIVATION_SCRIPT
end
