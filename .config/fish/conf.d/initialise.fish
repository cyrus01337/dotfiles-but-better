#!/usr/bin/env fish
for script in $__fish_config_dir/conf.d/*/*{,/*}.fish
    source $script
end

if command -q systemd-analyze; and not set -q INITIALISED
    systemd-analyze
end

set INITIALISED true
