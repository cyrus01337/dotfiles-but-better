#!/usr/bin/env bash
set -e

CONFIGURATIONS_REPOSITORY_URL="https://github.com/cyrus01337/configurations.git"

auto-detect-package-manager() {
    NOT_FOUND=0

    if [[ -f "$PWD/package-lock.json" ]]; then
        echo "npm"
    elif [[ -f "$PWD/yarn.lock" ]]; then
        echo "yarn"
    elif [[ -f "$PWD/pnpm-lock.yaml" ]]; then
        echo "pnpm"
    elif [[ -f "$PWD/bun.lockb" ]]; then
        echo "bun"
    else
        echo "$NOT_FOUND"
    fi
}

initialise-submodules() {
    if [[ ! -f "$PWD/.gitmodules" ]]; then
        echo "No .gitmodules file found in directory $PWD"

        return 1
    elif [[ ! "$(which git)" ]]; then
        echo "Git not found which submodules require, please install Git"

        return 1
    elif [[ "$INITIALISED_GIT_SUBMODULES" = true ]]; then
        echo "Git submodules have already been initialised by a previous fragment, skipping..."

        return 0
    fi

    path_pattern="\s+path = (.+)"

    while IFS= read -r line; do
        if [[ "$line" =~ "$path_pattern" ]]; then
            submodule_filepath="${BASH_REMATCH[1]}"
            is_empty="$(ls -A $submodule_filepath)"

            if [[ ! "$is_empty" ]]; then
                continue
            fi

            git submodule init "$submodule_filepath"
        fi
    done < ".gitmodules"

    export INITIALISED_GIT_SUBMODULES=true
}

get-configuration-directory() {
    unparsed_submodule_urls="$(git config -f .gitmodules -l | grep 'url')"
    path_found=""

    for line in "$unparsed_submodule_urls"; do
        if [[ "$line" =~ submodule\.(.+)\..+$CONFIGURATIONS_REPOSITORY_URL ]]; then
            path_found="${BASH_REMATCH[1]}"

            break;
        fi
    done

    echo "$path_found"
}

fragments="$@"
package_manager="$(auto-detect-package-manager)"

if [[ ! "$package_manager" ]]; then
    echo "Unable to auto-detect package manager - no known lockfile was found in the current working directory"

    return 1
fi

configurations_directory_found="$(get-configuration-directory)"

if [[ ! "$configurations_directory_found" ]]; then
    echo "Configurations repository not registered as submodule, please register before bootstrapping"

    return 1
fi

for fragment in $fragments; do
    $configurations_directory_found/devcontainers/fragments/$fragment.sh "$package_manager"
done
