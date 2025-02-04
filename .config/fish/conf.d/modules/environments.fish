#!/usr/bin/env fish
set ENVIRONMENTS_DIRECTORY "$__fish_config_dir/completions/environments"

function ssh-wp-engine
    set environment_filename $argv[1]

    if not string length --quiet $environment_filename
        return 1
    end

    set environment_filepath "$ENVIRONMENTS_DIRECTORY/$environment_filename"
    set environment (cat $environment_filepath 2> /dev/null)

    if not test -f $environment_filepath || test $status != 0
        echo "$environment_filename is an invalid environment"

        return 1
    end

    if not string length --quiet $environment
        set environment $environment_filename
    end

    ssh -t "$environment@$environment.ssh.wpengine.net" "cd ~/sites/$environment; bash --login"
end

function scp-plugin-wp-engine
    set plugin $argv[1]
    set environment $argv[2]

    if not string length --quiet $plugin
        set plugin $PWD
    end

    scp -O $plugin "$environment@$environment.ssh.wpengine.net:~/sites/$environment"
end
