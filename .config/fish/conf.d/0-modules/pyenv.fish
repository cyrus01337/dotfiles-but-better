#!/usr/bin/env fish
set -x PYENV_ROOT "$HOME/.local/share/pyenv"
set -x PYENV_VIRTUALENV_DISABLE_PROMPT true
set VENV_ACTIVATION_SCRIPT ".venv/bin/activate"

if test -d $PYENV_ROOT
    fish_add_path "$PYENV_ROOT/bin"

    if command -q pyenv
        eval "$(pyenv init -)" &> /dev/null
        eval "$(pyenv virtualenv-init -)" &> /dev/null
    end
else if test -f $VENV_ACTIVATION_SCRIPT
    source $VENV_ACTIVATION_SCRIPT
end

return 0
