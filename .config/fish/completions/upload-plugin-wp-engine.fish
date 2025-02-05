#!/usr/bin/env fish
set -l ENVIRONMENTS_DIRECTORIES (ls $__fish_config_dir/completions/environments/)

complete --command upload-plugin-wp-engine --no-files
# TODO: Refine plugin directory detection by searching for PHP project artifacts
complete \
    --command upload-plugin-wp-engine \
    --exclusive \
    --condition "__fish_is_first_arg" \
    --arguments "(__fish_complete_directories)"
complete \
    --command upload-plugin-wp-engine \
    --require-parameter \
    --condition "not __fish_is_first_arg; and test (__fish_number_of_cmd_args_wo_opts) = 2" \
    --arguments "$ENVIRONMENTS_DIRECTORIES"
