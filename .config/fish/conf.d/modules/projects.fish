#!/usr/bin/env fish
set PROJECTS_DIRECTORY "$HOME/Projects/"
set INTERRUPTED_OR_FATAL_ERROR 130
set -l FZF_FLAGS -1 --cycle --no-mouse --no-scrollbar --ellipsis ...

if test -d $PROJECTS_DIRECTORY
    function get_current_group
        set -l groups (ls $PROJECTS_DIRECTORY)

        if test (count $groups) = 0
            echo ""

            return 1
        else if test (count $groups) = 1
            echo $groups[1]

            return 0
        end

        for group in $groups
            if not string match -q "*$group*" $PWD
                continue
            end

            echo $group

            return 0
        end

        echo ""

        return 1
    end

    # TODO: Refactor all prompts to a singular function
    function prompt_for_group
        set -l groups (ls -r $PROJECTS_DIRECTORY)

        if test (count $groups) = 0
            echo ""

            return 1
        else if test (count $groups) = 1
            echo $groups[1]

            return 0
        end

        set group (ls -r $PROJECTS_DIRECTORY | fzf $FZF_FLAGS)

        echo $group

        if test "$group" = ""
            return $INTERRUPTED_OR_FATAL_ERROR
        end

        return 0
    end

    function prompt_for_project
        set group $argv[1]
        set -l projects (ls -l $PROJECTS_DIRECTORY/$group)

        if test (count $projects) = 0
            echo ""

            return 1
        else if test (count $projects) = 1
            echo $projects[1]

            return 0
        end

        set project (ls -r "$PROJECTS_DIRECTORY/$group" | fzf $FZF_FLAGS)

        echo $project

        if test "$project" = ""
            return $INTERRUPTED_OR_FATAL_ERROR
        end

        return 0
    end

    function prompt_for_subproject
        set group $argv[1]
        set project $argv[2]
        set -l subprojects (ls -r "$PROJECTS_DIRECTORY/$group/$project")

        if test (count $subprojects) = 0
            echo ""

            return 1
        else if test (count $subprojects) = 1
            echo $subprojects[1]

            return 0
        end

        set subproject (ls -r "$PROJECTS_DIRECTORY/$group/$project" | fzf $FZF_FLAGS)

        echo $subproject

        if test "$subproject" = ""
            return $INTERRUPTED_OR_FATAL_ERROR
        end

        return 0
    end

    function projects
        set selected_group ""

        argparse "r/root" "g/groups" -- $argv

        if not set -q _flag_root
            set selected_group (get_current_group)
        end

        if test "$selected_group" = ""
            set selected_group (prompt_for_group)
            set prompt_status $status

            if test $prompt_status = 1
                echo "Unable to prompt for group"
            end

            if test $prompt_status != 0
                return $prompt_status
            end
        end

        if set -q _flag_groups
            cd "$PROJECTS_DIRECTORY/$selected_group"

            return 0
        end

        set selected_project (prompt_for_project $selected_group)
        set prompt_status $status

        if test $prompt_status = 1
            echo "Unable to prompt for project"
        end

        if test $prompt_status != 0
            return $prompt_status
        end

        # TODO: Create a modular system allowing for special-casing certain
        # directories, namely for granular management of special-cases e.g. below
        if test "$selected_project" = "lamna"
            set selected_subproject (prompt_for_subproject $selected_group $selected_project)

            cd "$PROJECTS_DIRECTORY/$selected_group/$selected_project/$selected_subproject"

            return 0
        end

        cd "$PROJECTS_DIRECTORY/$selected_group/$selected_project"

        return 0
    end
end
