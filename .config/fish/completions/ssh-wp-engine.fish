#!/usr/bin/env fish
set -l ENVIRONMENTS_DIRECTORY (ls $__fish_config_dir/completions/environments/)

complete --command ssh-wp-engine --no-files
complete --command ssh-wp-engine --require-parameter --arguments "$ENVIRONMENTS_DIRECTORY"
