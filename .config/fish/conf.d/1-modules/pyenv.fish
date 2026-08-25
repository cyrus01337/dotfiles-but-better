#!/usr/bin/env fish
set -x PYENV_ROOT "$HOME/.local/share/pyenv"

if test -d $PYENV_ROOT
    fish_add_path "$PYENV_ROOT/bin"
end

if command -q pyenv &> /dev/null
    pyenv init - fish | source
    pyenv virtualenv-init - fish | source
end
