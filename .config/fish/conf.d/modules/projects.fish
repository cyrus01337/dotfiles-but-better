#!/usr/bin/env fish
set PROJECTS_DIRECTORY "$HOME/Projects/"

if test -d $PROJECTS_DIRECTORY
    function projects
        set INTERRUPTED_OR_FATAL_ERROR 130
        set -l FZF_FLAGS -1 --cycle --no-mouse --no-scrollbar --ellipsis ...
        set -l groups (ls $PROJECTS_DIRECTORY)
        set selected_group ""

        if test (count $groups) = 0
            return 1
        end

        for group in $groups
            if not string match -q "*$group*" $PWD
                continue
            end

            set selected_group $group

            break
        end

        if test "$selected_group" = ""
            set selected_group (ls -r $PROJECTS_DIRECTORY | fzf $FZF_FLAGS)

            if test "$selected_group" = ""
                return $INTERRUPTED_OR_FATAL_ERROR
            end
        end

        set -l objects (ls -l $PROPTECTS_DIRECTORY/$selected_group)

        if test (count $objects) = 0
            return 1
        end

        set selected_project (ls -r "$PROJECTS_DIRECTORY/$selected_group" | fzf $FZF_FLAGS)

        if test "$selected_project" = ""
            return $INTERRUPTED_OR_FATAL_ERROR
        end

        # TODO: Create a modular system allowing for special-casing certain
        # directories, namely for granular management of special-cases e.g. below
        if test "$selected_project" != "lamna"
            cd "$PROJECTS_DIRECTORY/$selected_group/$selected_project"

            return 0
        end

        set selected_subproject (ls -r "$PROJECTS_DIRECTORY/$selected_group/$selected_project" | fzf $FZF_FLAGS)

        if test "$selected_subproject" = ""
            return 0
        end

        cd "$PROJECTS_DIRECTORY/$selected_group/$selected_project/$selected_subproject"
    end
end
