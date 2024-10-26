#!/usr/bin/env bash
set -e

package_manager="$1"

if [ ! -d .husky/_ ]; then
    $package_manager prepare
fi
