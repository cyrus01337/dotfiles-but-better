#!/usr/bin/env fish
if command -q git
    alias g="git"
    alias gb="git branch"
    alias gch="git checkout"
    alias gcl="git clone --recurse-submodules"
    alias gca="git commit --amend"
    alias gcn="git config"
    alias gco="git commit"
    alias gcog="git config --global"
    alias gd="git diff"
    alias gds="git diff --staged"
    alias gi="git init"
    alias gm="git merge"
    alias gpl="git pull"
    alias gps="git push"
    alias gr="git remote"
    alias gra="git remote add"
    alias gst="git status"
    alias gsm="git submodule"

    alias git-add-submodule "git submodule add"
    alias git-initialise-submodules "git submodule update --init --recursive"
    alias git-save-credentials "git config --global credential.helper store"
    alias git-update-submodules "git submodule update --remote"
    alias gasm="git-add-submodule"
    alias gism="git-initialise-submodules"
    alias gusm="git-update-submodules"
    alias gusmr="git-update-submodules --recursive"

    function ga --wraps "git add"
        set files $argv

        if not [ $files ]
            set files "."
        end

        git add $files
    end

    function gpsu --wraps "git push"
        set branch $argv[1]

        if not [ $branch ]
            set branch "main"
        end

        git push -u origin $branch
    end

    function fix-formatting-commit
        p format
        git add .
        git commit -m "Fix formatting"
        git push
    end

    function git-fetch-all-branches
        for remote in (git branch -r | grep -v '\->' | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g")
            set trimmed_remote (string trim $remote)

            echo git branch --track (string replace -r -a "^\s*origin/" "" "$remote") "$trimmed_remote"
        end

        git fetch --all
        git pull --all
    end

    function git-submodule-remove
        set submodule $argv[1]

        git submodule deinit -f -- $submodule
        rm -rf .git/modules/$submodule
        git rm --cached $submodule
    end
end

if command -q gh
    function gh-repo-clone --wraps "gh repo clone"
        set repository_shorthand $argv[1]
        set matches (string match -r "(.+)/(.+)" $repository_shorthand)
        set author $matches[1]
        set repository $matches[2]

        if not [ $author ]; and [ $GITHUB_AUTHOR ]
            set author $GITHUB_AUTHOR
        end

        gh repo clone "git@github.com:$author/$repository" -- --recurse-submodules
    end

    alias ghrc="gh-repo-clone"

    function gh-clone-all-repositories
        if not command -q parallel
            echo "GNU Parallel is needed to run this"

            return 127
        end

        # https://stackoverflow.com/a/64915484
        parallel -j (nproc) gh repo clone "git@github.com:cyrus01337/{}" -- --recurse-submodules ::: (gh repo list --json "name" --jq ".[].name" --limit 1000)
    end
end

return 0
