#!/usr/bin/env fish
set ENVIRONMENTS_DIRECTORY "$__fish_config_dir/completions/environments"

function ssh-wp-engine
    set environment_filename $argv[1]

    if not string length --quiet $environment_filename
        return 1
    end

    set environment_filepath "$ENVIRONMENTS_DIRECTORY/$environment_filename"
    set environment (cat $environment_filepath 2> /dev/null)

    if test $status != 0 || not test -f "$environment_filepath"
        echo "$environment_filename is an invalid environment"

        return 1
    end

    if not string length --quiet $environment
        set environment $environment_filename
    end

    ssh -t "$environment@$environment.ssh.wpengine.net" "cd ~/sites/$environment; bash --login"
end

function upload-plugin-wp-engine
    set plugin_path $argv[1]
    set plugin_name (basename $plugin_path)
    set environment_filename $argv[2]
    set environment_filepath "$ENVIRONMENTS_DIRECTORY/$environment_filename"

    if not test -d $plugin_path
        echo "Path given must be a directory"
    end

    if test $status != 0 || not test -f "$environment_filepath"
        echo "$environment_filename is an invalid environment"

        return 1
    end

    set environment (cat $environment_filepath 2> /dev/null)

    if not string length --quiet $environment
        set environment $environment_filename
    end

    rsync -aPRz --delete $plugin_path "$environment@$environment.ssh.wpengine.net:~/sites/$environment/wp-content/plugins/$plugin_name"
end
