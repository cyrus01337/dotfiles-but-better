#!/usr/bin/env bash
set -e

export HUSKY=0
package_manager="$1"

$package_manager install

if [[ $package_manager = "bun" ]]; then
    $package_manager pm trust --all || true
fi
