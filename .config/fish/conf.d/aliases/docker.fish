#!/usr/bin/env fish
if command -q docker
    alias d="docker"
    alias db="docker build"
    alias dcb="dc build"
    alias dcom="docker compose"
    alias dcon="docker container"
    alias dcr="dc down && dc up"
    alias di="docker image ls"
    alias dpl="docker pull"
    alias dps="docker ps"
    alias dpsa="docker ps -a"
    alias drmi="docker rmi"
    alias dv="docker volume"

    alias docker-images="docker image ls"

    function docker-prune-all --wraps "docker system prune"
        echo "y" | docker system prune
    end

    function docker-remove-by-name --wraps "docker rmi"
        docker rmi (docker images "$name" -a -q)
    end

    function docker-remove-untagged-images --wraps "docker rmi -f"
        docker images --filter "dangling=true" -q --no-trunc | xargs -I {} parallel rmi -f {}
    end

    function docker-build-test-image --wraps "docker build -t test"
        set context $argv[1]
        set flags $argv[2..]

        if set -q context
            set context "."
        end

        docker build -t test $flags $context
    end
end
