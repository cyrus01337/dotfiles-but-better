#!/usr/bin/env fish
set CURRENT_DIRECTORY (pwd)
set -l ENVIRONMENTS_DIRECTORIES (ls $__fish_config_dir/completions/environments/)
# TODO: Refine plugin directory detection by searching for PHP project artifacts
set -l CURRENT_DIRECTORIES (path filter --type dir (ls $CURRENT_DIRECTORY)) "./"

complete --command scp-plugin-wp-engine --no-files
complete --command scp-plugin-wp-engine --condition "__fish_use_subcommand" --arguments "$CURRENT_DIRECTORIES"
complete \
    --command scp-plugin-wp-engine \
    --require-parameter \
    --condition "__fish_seen_subcommand_from $CURRENT_DIRECTORIES; and not __fish_seen_subcommand_from $ENVIRONMENTS_DIRECTORIES" \
    --arguments "$ENVIRONMENTS_DIRECTORIES"
