#!/usr/bin/env fish
alias re="sudo reboot now"

function switch-and-link
    set target $argv[1]
    set destination $argv[2]

    if not test -f $target; and not test -d $target
        echo "target must be an existing file or directory"

        return 1
    end

    if test -z $destination; or not test -d $destination
        set destination $PWD
    end

    set filename (basename $target)

    mv $target "$destination/$filename"
    ln -s "$destination/$filename" $target
end
