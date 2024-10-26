#!/usr/bin/env fish
set -x AUTO_UPDATE_CHEZMOI_SERVICE "$HOME/.config/systemd/user/chezmoi.service"

if which chezmoi &> /dev/null
and ! systemctl --user is-enabled --quiet chezmoi.service
and [ -f $AUTO_UPDATE_CHEZMOI_SERVICE ]
and [ ! -f "/.dockerenv" ]
    echo "chezmoi auto-update service found, don't forget to enable it with \"systemctl --user enable --now chezmoi.service\""
end
