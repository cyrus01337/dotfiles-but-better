#!/usr/bin/env fish
for function_ in (find $__fish_config_dir/functions/ -type f -not \( -path '*/__*' \))
    . $function_
end

for script in $__fish_config_dir/conf.d/before/*.fish
    source $script

    set cached_status $status

    if test $cached_status != 0
        echo "Before script $script failed with exit code $cached_status"
    end
end

for module in $__fish_config_dir/conf.d/modules/*.fish
    source $module

    set cached_status $status

    if test $cached_status != 0
        echo "Module $module failed with exit code $cached_status"
    end
end

for package in $__fish_config_dir/conf.d/packages/*.fish
    source $package

    set cached_status $status

    if test $cached_status != 0
        echo "Package $package failed with exit code $cached_status"
    end
end

for aliases in $__fish_config_dir/conf.d/aliases/*.fish
    source $aliases

    set cached_status $status

    if test $cached_status != 0
        echo "Aliases script $aliases failed with exit code $cached_status"
    end
end
