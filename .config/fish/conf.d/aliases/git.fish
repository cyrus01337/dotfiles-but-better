#!/usr/bin/env fish
if which git &> /dev/null
    alias g="git"
    alias gb="git branch"
    alias gch="git checkout"
    alias gcl="git clone"
    alias gco="git commit"
    alias gi="git init"
    alias gm="git merge"
    alias gr="git remote"
    alias gra="git remote add"
    alias gpl="git pull"
    alias gps="git push"
    alias gsm="git submodule"

    function ga --wraps "git add"
        if not [ $argv[1] ]
            git add .
        else
            git add $argv
        end
    end

    function gpsu --wraps "git push"
        if not [ $argv[1] ]
            git push -u origin main
        else
            git push -u origin $argv
        end
    end

    function fix-formatting-commit
        p format
        git add .
        git commit -m "Fix formatting"
        git push
    end

    function git-init-submodule --wraps "git submodule update"
        git submodule update --init --recursive
    end

    function git-update-submodule --wraps "git submodule update --recursive --remote"
        git submodule update --recursive --remote
    end

    alias gism="git-init-submodule"
    alias gusm="git-update-submodule"

    function git-fetch-all-branches
        for remote in (git branch -r | grep -v '\->' | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g")
            set trimmed_remote (string trim $remote)

            echo git branch --track (string replace -r -a "^\s*origin/" "" "$remote") "$trimmed_remote"
        end

        git fetch --all
        git pull --all
    end

    function git-submodule-remove
        git submodule deinit -f -- $submodule
        rm -rf .git/modules/$submodule
        git rm --cached $submodule
    end
end
