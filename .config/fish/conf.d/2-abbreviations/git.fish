#!/usr/bin/env fish
if command -q git
    abbr --add g "git"
    abbr --add gb "git branch"
    abbr --add gch "git checkout"
    abbr --add gcl "git clone --recurse-submodules"
    abbr --add gca "git commit --amend"
    abbr --add gcn "git config"
    abbr --add gco "git commit"
    abbr --add gcog "git config --global"
    abbr --add gd "git diff"
    abbr --add gds "git diff --staged"
    abbr --add gi "git init"
    abbr --add gm "git merge"
    abbr --add gpl "git pull"
    abbr --add gps "git push"
    abbr --add gr "git remote"
    abbr --add gra "git remote add"
    abbr --add gst "git status"
    abbr --add gsm "git submodule"

    abbr --add git-add-submodule "git submodule add"
    abbr --add git-initialise-submodules "git submodule update --init --recursive"
    abbr --add git-save-credentials "git config --global credential.helper store"
    abbr --add git-update-submodules "git submodule update --remote"
    abbr gasm "git submodule add"
    abbr gism "git submodule update --init --recursive"
    abbr gusm "git submodule update --remote"
    abbr gusmr "git submodule update --remote --recursive"

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
        set -a matches (string match -r "(?:(.+)\/)?(.+)" $repository_shorthand)
        set author $matches[2]
        set repository $matches[3]

        if not test $repository
            set repository $author
            set author $GITHUB_USERNAME
        end

        gh repo clone "git@github.com:$author/$repository" -- --recurse-submodules
    end

    abbr --add ghrc "gh-repo-clone"

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
