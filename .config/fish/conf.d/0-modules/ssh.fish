#!/usr/bin/env fish
if command -q ssh
    set ENVIRONMENTS_DIRECTORY "$__fish_config_dir/completions/environments"

    function ssh-wp-engine
        set environment_filename $argv[1]

        if not string length --quiet $environment_filename
            return 1
        end

        set environment_filepath "$ENVIRONMENTS_DIRECTORY/$environment_filename"
        set environment (cat $environment_filepath 2> /dev/null)

        if test $status != 0 || not test -f $environment_filepath
            echo "$environment_filename is an invalid environment"

            return 1
        end

        if not string length --quiet $environment
            set environment $environment_filename
        end

        ssh -t "$environment@$environment.ssh.wpengine.net" "cd ~/sites/$environment; bash --login"
    end

    function upload-plugin-wp-engine
        set plugin_path (realpath $argv[1])
        set plugin_name (basename $plugin_path)
        set environment_filename $argv[2]
        set environment_filepath "$ENVIRONMENTS_DIRECTORY/$environment_filename"

        if not test -d $plugin_path
            echo "Path given must be a directory"
        end

        if test $status != 0 || not test -f $environment_filepath
            echo "$environment_filename is an invalid environment"

            return 1
        end

        set environment (cat $environment_filepath 2> /dev/null)

        if not string length --quiet $environment
            set environment $environment_filename
        end

        set destination "~/sites/$environment/wp-content/plugins/$plugin_name"

        echo "Uploading $plugin_name to $environment at $destination"
        rsync -aPRz --delete --info=progress2 $plugin_path "$environment@$environment.ssh.wpengine.net:$destination"
    end

    function generate-ssh-key
        set name (string join "" $argv[1] "_ed25519")

        ssh-keygen -a 10 -b 4096 -f "$HOME/.ssh/$name" -t ed25519
    end
end

return 0
