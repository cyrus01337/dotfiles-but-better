#!/usr/bin/env fish
abbr re "sudo reboot now"
abbr shu "sudo shutdown now"
abbr --set-cursor mkoptdir "set target \"/opt/%\"; sudo mkdir \$target && sudo chown -R \$USER:\$USER \$target && sudo chmod -R u+rwX \$target; set --erase target"

return 0
