#!/usr/bin/env fish
for script in $__fish_config_dir/conf.d/{*/*,*/*/*}.fish
    source $script
end
