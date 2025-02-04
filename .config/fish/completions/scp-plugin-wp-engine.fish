#!/usr/bin/env fish
set -l ENVIRONMENTS_DIRECTORIES (ls $__fish_config_dir/completions/environments/)
set CURRENT_DIRECTORY (pwd)
set CURRENT_DIRECTORIES (path filter --type dir (ls $CURRENT_DIRECTORY))

complete --command scp-plugin-wp-engine --no-files
complete --command scp-plugin-wp-engine --condition "__fish_use_subcommand" --arguments "$CURRENT_DIRECTORIES"
complete --command scp-plugin-wp-engine --require-parameter --condition "__fish_seen_subcommand_from $CURRENT_DIRECTORIES" --arguments "$ENVIRONMENTS_DIRECTORIES"
