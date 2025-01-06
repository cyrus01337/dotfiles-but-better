#!/usr/bin/env fish
set PROJECTS_DIRECTORY "$HOME/Projects/"

if test -d $PROJECTS_DIRECTORY
    function projects
        set EMPTY ""
        set INTERRUPTED_OR_FATAL_ERROR 130
        set -l FZF_FLAGS -1 --cycle --no-mouse --no-scrollbar --ellipsis ...
        set group (ls -r $PROJECTS_DIRECTORY | fzf $FZF_FLAGS)

        if test "$group" = "$EMPTY"
            return $INTERRUPTED_OR_FATAL_ERROR
        end

        set -l objects (ls -l $PROPTECTS_DIRECTORY/$group)

        if test (count $objects) = 0
            return 1
        end

        set project (ls -r "$PROJECTS_DIRECTORY/$group" | fzf $FZF_FLAGS)

        if test "$project" = "$EMPTY"
            return $INTERRUPTED_OR_FATAL_ERROR
        end

        cd "$PROJECTS_DIRECTORY/$group/$project"
    end
end
