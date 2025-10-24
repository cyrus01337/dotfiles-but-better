#!/usr/bin/env fish
if command -q git
    abbr g "git"
    abbr ga "git add"
    abbr gasm "git submodule add"
    abbr gb "git branch"
    abbr gca "git commit --amend"
    abbr gch "git checkout"
    abbr gcl "git clone --recurse-submodules"
    abbr gcn "git config"
    abbr gco "git commit"
    abbr gcog "git config --global"
    abbr gd "git diff"
    abbr gds "git diff --staged"
    abbr gi "git init"
    abbr gism "git submodule update --init --recursive"
    abbr gm "git merge"
    abbr gpl "git pull"
    abbr gps "git push"
    abbr gpsu "git push --set-upstream origin (git branch --show-current)"
    abbr gr "git remote"
    abbr gra "git remote add"
    abbr gsc "git config --global credential.helper store"
    abbr gsm "git submodule"
    abbr gst "git status"
    abbr gusm "git submodule update --remote"
    abbr gusmr "git submodule update --remote --recursive"

    abbr git-add-submodule "git submodule add"
    abbr git-fix-formatting-commit "p format && git add . && git commit -m \"Fix formatting\" && git push"
    abbr git-initialise-submodules "git submodule update --init --recursive"
    abbr git-push-upstream "git push --set-upstream origin (git branch --show-current)"
    abbr git-save-credentials "git config --global credential.helper store"
    abbr git-update-submodules "git submodule update --remote"

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
        set destination $argv[2]
        set -a matches (string match -r "(?:(.+)\/)?(.+)" $repository_shorthand)
        set author $matches[2]
        set repository $matches[3]

        if not test $repository
            set repository $author
            set author $GITHUB_USERNAME
        end

        gh repo clone "git@github.com:$author/$repository" $destination -- --recurse-submodules --jobs (nproc)
    end

    abbr ghrc "gh-repo-clone"

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
