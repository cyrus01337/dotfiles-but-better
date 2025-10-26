#!/usr/bin/env fish
if command -q docker &> /dev/null
    abbr d "docker"
    abbr db "docker build"
    abbr dcb "dc build"
    abbr dcom "docker compose"
    abbr dcon "docker container"
    abbr dcr "dc down && dc up"
    abbr di "docker image ls"
    abbr dpl "docker pull"
    abbr dprs "docker system prune"
    abbr dps "docker ps"
    abbr dpsa "docker ps -a"
    abbr drm "docker rm"
    abbr drmf "docker rm -f"
    abbr drmi "docker rmi"
    abbr dv "docker volume"

    abbr docker-images "docker image ls"

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
