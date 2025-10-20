#!/usr/bin/env fish
set CONFIGURATION_FILEPATH "$XDG_CONFIG_HOME/edit-fzf/files.toml"
set -l FZF_FLAGS -1 --cycle --no-mouse --no-scrollbar --ellipsis ... --layout reverse

function log
    echo -e "\x1b[33;1m$argv...\x1b[0m" >&2
end

function log_error
    set message $argv[1]
    set sleep_time $argv[2]

    echo -e "\x1b[31;1m$message...\x1b[0m" >&2

    if test $sleep_time
        sleep $sleep_time
    end
end

function in_shell
    set running_process (tmux display-message -p "#{window_name}")

    test $running_process = "fish"; or test $running_process = "bash"
end

function run_depdendant_shell_command
    set command_ $argv[1]

    if in_shell
        if test $TMUX
            # clear
            tmux send-keys "$command_" C-m
        else
            eval "$command_"
        end
    end
end

function edit-fzf --inherit-variable CONFIGURATION_DIRECTORY --inherit-variable FZF_FLAGS
    if not command -q fzf &> /dev/null
        log_error "fzf is required to run this, please install fzf"

        return 127
    else if not command -q qq &> /dev/null
        log_error "qq is required to run this, please install qq"

        return 127
    else if not test -f $CONFIGURATION_FILEPATH
        log_error "Unable to find configuration file at $CONFIGURATION_FILEPATH"

        return 1
    end

    set chosen_file_name (
        qq \
            --monochrome-output \
            --raw-output \
            --input toml \
            --output json \
            '.files | keys[]' \
            $CONFIGURATION_FILEPATH \
            | fzf $FZF_FLAGS
    )

    if test "$chosen_file_name" = ""
        return 1
    end

    set filter ".files | to_entries[] | select(.key == \"$chosen_file_name\") | .value"
    set chosen_filepath (
        qq \
            --monochrome-output \
            --raw-output \
            --input toml \
            --output json \
            "$filter" \
            $CONFIGURATION_FILEPATH
    )
    echo $chosen_file_name
    echo $chosen_filepath

    if test "$chosen_filepath" = ""
        log_error "Missing entry in configuration"

        return 127
    end

    run_depdendant_shell_command "n $chosen_filepath"

    if test "$chosen_file_name" = "fish"; and command -q fish &> /dev/null
        run_depdendant_shell_command "source $XDG_CONFIG_HOME/fish/config.fish"
    else if test "$chosen_file_name" = "niri"; and command -q niri &> /dev/null
        run_depdendant_shell_command "niri validate"
    else if test "$chosen_file_name" = "nixos"; and test -d /etc/nixos
        run_depdendant_shell_command "nr"
    else if test "$chosen_file_name" = "sway"; and command -q sway &> /dev/null
        run_depdendant_shell_command "sway reload"
    else if test "$chosen_file_name" = "tmux"; and command -q tmux &> /dev/null
        run_depdendant_shell_command "tmux source $XDG_CONFIG_HOME/tmux/tmux.conf"
    end

    return 0
end
