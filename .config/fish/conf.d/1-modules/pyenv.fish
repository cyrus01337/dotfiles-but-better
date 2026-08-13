#!/usr/bin/env fish
set -x PYENV_ROOT "$HOME/.pyenv"

if test -d $PYENV_ROOT
    fish_add_path "$PYENV_ROOT/bin"

    pyenv init - fish | source
    pyenv virtualenv-init - fish | source
end
