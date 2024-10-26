#!/usr/bin/env bash
set -e

if [[ "$INITIALISED_GIT_SUBMODULES" = false ]]; then
    initialise-submodules
fi

git submodule update --remote --recursive
