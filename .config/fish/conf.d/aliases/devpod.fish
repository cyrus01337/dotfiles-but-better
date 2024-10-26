#!/usr/bin/env fish
if which devpod &> /dev/null
    function devpod-ssh-cwd --wraps ssh
        ssh (basename $PWD).devpod
    end

    function devpod-recreate --wraps "devpod up"
        devpod down . &> /dev/null
        devpod up --recreate .
    end
end
