set -l environments (ls $__fish_config_dir/completions/ssh-wp-engine/)

complete -c ssh-wp-engine -f
complete -c ssh-wp-engine -ra "$environments"
