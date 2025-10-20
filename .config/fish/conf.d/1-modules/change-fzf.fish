#!/usr/bin/env fish
set CONFIGURATION_FILEPATH "$XDG_CONFIG_HOME/change-fzf/directories.toml"
set -l FZF_FLAGS -1 --cycle --no-mouse --no-scrollbar --ellipsis ... --layout reverse
set -l OPTIONS "directory" "display-manager"
set -l DISPLAY_MANAGERS "greetd" "sddm"

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

function handle_directory --inherit-variable CONFIGURATION_FILEPATH --inherit-variable FZF_FLAGS --inherit-variable OPTIONS
    if not test -f $CONFIGURATION_FILEPATH
        log_error "Unable to find configuration file at $CONFIGURATION_FILEPATH"

        return 1
    end

    set chosen_directory_name (
        qq \
            --monochrome-output \
            --raw-output \
            --input toml \
            --output json \
            '.directories | keys[]' \
            $CONFIGURATION_FILEPATH \
            | fzf $FZF_FLAGS
    )

    if test "$chosen_directory_name" = ""
        return 1
    end

    set filter ".directories | to_entries[] | select(.key == \"$chosen_directory_name\") | .value"
    set directory_path (
        qq \
            --monochrome-output \
            --raw-output \
            --input toml \
            --output json \
            "$filter" \
            $CONFIGURATION_FILEPATH
    )

    if test "$directory_path" = ""
        log_error "Missing entry in configuration"

        return 127
    end

    if in_shell
        if test $TMUX
            clear
            tmux send-keys "cd $directory_path" C-m
        else
            cd $full_project_path
        end
    end

    return 0
end

function handle_display_manager --inherit-variable DISPLAY_MANAGERS --inherit-variable FZF_FLAGS
    set chosen_display_manager $argv[1]

    if test "$argv[1]" != ""
        set chosen_display_manager $argv[1]
    else
        set chosen_display_manager (echo -e (string join "\n" $DISPLAY_MANAGERS) | fzf $FZF_FLAGS)
    end

    set current_display_manager (
        systemctl status display-manager --no-pager --plain --quiet \
            | grep -oP '(?<=\x{25cf} )(.+)(?=\.service.+)'
    )

    if test "$current_display_manager" = "$chosen_display_manager"
        log_error "You are already using $chosen_display_manager" 3

        return 1
    end

    log "Changing display manager to $chosen_display_manager"

    sudo systemctl disable --now $default_display_manager \
        && sudo systemctl enable --now $chosen_display_manager \
        &> /dev/null
end

function change-fzf --inherit-variable OPTIONS --inherit-variable FZF_FLAGS
    if not command -q fzf &> /dev/null
        log_error "fzf is required to run this, please install fzf"

        return 127
    else if not command -q qq &> /dev/null
        log_error "qq is required to run this, please install qq"

        return 127
    end

    set option (echo -e (string join "\n" $OPTIONS) | fzf $FZF_FLAGS)

    if test "$option" = ""
        return 1
    else if test "$option" = "directory"
        handle_directory

        return $status
    else if test "$option" = "display-manager"
        handle_display_manager

        return $status
    end
end
