#!/usr/bin/env fish
# https://medium.com/@chantastic/p-525e68f17e56
set P_LOGS
set P_LOADED
set P_FILE (status --current-filename)
set P_DIRECTORY (dirname $P_FILE)
set P_SUPPORTED_LANGUAGES "javascript"
set P_SUPPORTED_SYSTEM_PACKAGE_MANAGERS "dnf"

if not set -q P_DISABLE_LOGGING
    set P_DISABLE_LOGGING false
end

function log
    set message $argv
    set -a P_LOGS "p: $message"
end

function teardown_aliases
    if functions | string match "p_teardown" &> /dev/null
        p_teardown

        set teardown_status $status

        if [ $teardown_status != 0 ]
            log "Teardown for $P_LOADED failed with exit code $teardown_status"
        end

        functions --erase p_teardown
    end

    return 0
end

function show_log
    if not set -q $P_LOGS[1]
        return 0
    end

    if [ $P_DISABLE_LOGGING = true ]; or [ $P_DISABLE_LOGGING = 1 ]
        set P_LOGS

        return 0
    end

    for message in $P_LOGS
        echo $message
    end

    set P_LOGS

    return 0
end

function loader_exists
    set script_path $argv[1]

    if not [ -f $script_path ]
        log "Skipping $name loader as not found..."

        return 1
    end

    return 0
end

function loader_runs
    set loader $argv[1]

    source $loader

    set loader_status $status

    if [ $loader_status != 0 ]; and [ $loader_status != 127 ]
        log "$name.fish failed with exit code $loader_status"
    end

    return $loader_status
end

function bootstrap
    set package_manager $argv[1]

    if not functions | string match "p_detect" &> /dev/null
        log "Unable to find detect hook function \"p_detect\" when loading $package_manager"

        return 1
    end

    if not p_detect
        log "$package_manager is currently unsupported, feature requests and PRs welcome!"
    end

    if not functions | string match "p_setup" &> /dev/null
        log "Unable to find detect hook function \"p_setup\" when loading $package_manager"

        return 1
    end

    if not p_setup
        log "Bootstrapping $name failed with exit code $bootstrap_status"
    end

    functions --erase p_detect p_setup

    return $setup_status
end

function process_loaders_from_list
    set names $argv

    for name in $names
        set script_path "$P_DIRECTORY/loaders/$name.fish"

        if not begin
            loader_exists $script_path
            and loader_runs $script_path
            and bootstrap $name
        end
            continue
        end

        set P_LOADED $name

        return 0
    end

    return 127
end

function auto_detect_package_manager
    if not set -q $P_LOADED[1]
        teardown_aliases

        set P_LOADED
    end

    set payload (process_loaders_from_list $P_SUPPORTED_LANGUAGES)

    if [ $status != 0 ]
        set payload (process_loaders_from_list $P_SUPPORTED_SYSTEM_PACKAGE_MANAGERS)
    end

    show_log

    return 0
end

function on_pwd_change --on-variable PWD
    set previously_loaded $P_LOADED

    auto_detect_package_manager

    if [ $previously_loaded != $P_LOADED ]
        set name $P_LOADED

        if not set -q P_LOADED[1]
            set name "<none>"
        end

        echo "p: Switching aliases for $name..."
    end
end

auto_detect_package_manager
