#!/usr/bin/env fish
if command -q docker &> /dev/null
    set USER_IN_DOCKER_GROUP (id -nG "$USER" | grep docker)

    function silence
        command $argv &> /dev/null

        return $status
    end

    function ollama
        echo "Preparing Ollama..."

        set using_existing_container false
        set ollama_container_id "$(docker ps --format '{{.ID}}' --filter 'name=ollama')"

        if [ $ollama_container_id != "" ]
            set using_existing_container true

            echo "Using existing Ollama container..."
        else
            if silence docker start ollama
                echo "Starting Ollama container..."
            else
                echo "Pulling Ollama image from Docker Hub..."
                docker pull ollama/ollama:rocm

                echo "Starting new Ollama container..."
                silence docker run \
                    -d \
                    -v ollama:/root/.ollama \
                    -p 11434:11434 \
                    --device /dev/kfd \
                    --device /dev/dri \
                    --name ollama \
                    ollama/ollama:rocm
            end

            set ollama_container_id "$(docker ps --format '{{.ID}}' --filter 'name=ollama')"
        end

        docker exec -it ollama ollama $argv

        if [ $using_existing_container = false ]
            echo "Stopping Ollama container..."
            silence docker stop ollama
        end
    end

    silence docker image ls

    if test $status != 0 ; and test -f /.dockerenv ; and test "$USER_IN_DOCKER_GROUP" != ""
        # There is a bug within devcontainers where if it uses
        # docker-outside-of-docker, running any Docker command fails despite
        # being assigned to the Docker group, so we modify the permissions of
        # the Docker socket only when inside a Docker/dev container
        silence sudo chmod 666 /run/docker.sock
    end
end

return 0
