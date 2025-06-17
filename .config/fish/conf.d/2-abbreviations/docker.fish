#!/usr/bin/env fish
if command -q docker
    abbr --add d "docker"
    abbr --add db "docker build"
    abbr --add dcb "dc build"
    abbr --add dcom "docker compose"
    abbr --add dcon "docker container"
    abbr --add dcr "dc down && dc up"
    abbr --add di "docker image ls"
    abbr --add dpl "docker pull"
    abbr --add dprs "docker system prune"
    abbr --add dps "docker ps"
    abbr --add dpsa "docker ps -a"
    abbr --add drm "docker rm"
    abbr --add drmf "docker rm -f"
    abbr --add drmi "docker rmi"
    abbr --add dv "docker volume"

    abbr --add docker-images "docker image ls"

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

return 0
