#!/usr/bin/env fish
if command -q nvim &> /dev/null
    function n --wraps nvim
        set PREVIOUS_DIRECTORY $PWD
        set target $argv[1]

        if test -z "$target"
            set target "."
        else if test -d $target
            cd $target

            set target "."
        else
            set directory (dirname $target)
            set target (basename $target)

            cd $directory
        end

        nvim $target
        cd $PREVIOUS_DIRECTORY
    end
end

return 0
