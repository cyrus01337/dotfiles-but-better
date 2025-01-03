if command -q ssh
    function ssh-wp-engine
        set environment $argv[1]

        ssh -t "$environment@$environment.ssh.wpengine.net" "cd sites/$environment; bash --login"
    end
end
