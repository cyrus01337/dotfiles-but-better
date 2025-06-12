#!/usr/bin/env fish
# https://medium.com/@chantastic/p-525e68f17e56
set P_LOADED
set P_FILE (status --current-filename)
set P_DIRECTORY (dirname $P_FILE)
set P_LOG_FILE "/tmp/p.log"
set P_SUPPORTED_DEVELOPMENT "web-development"
set P_SUPPORTED_SYSTEM_PACKAGE_MANAGERS "dnf pacman"

if not set -q P_DEBUG
    set P_DEBUG false
end

function log
    set message "$argv"

    if test $P_DEBUG = true
        echo $message >> $P_LOG_FILE
    end
end

function add_log_header
    set unix_timestamp (date +%s.%N)
    log ""
    log "[$unix_timestamp]"
end

function add_log_footer
    log ""
end

function teardown_aliases
    if functions | string match "p_teardown" &> /dev/null
        log "Found teardown hook, running..."

        p_teardown

        set teardown_status $status

        if test $teardown_status != 0
            log "Teardown for $P_LOADED failed with exit code $teardown_status"
        end

        functions --erase p_teardown
    else
        log "No teardown hook found, skipping step..."
    end

    return 0
end

function loader_exists
    set script_path $argv[1]

    if not test -f $script_path
        log "Skipping $name loader as not found..."

        return 1
    end

    return 0
end

function loader_runs
    set loader $argv[1]

    source $loader

    set loader_status $status

    if test $loader_status != 0; and test $loader_status -ne 127
        log "$name.fish failed with exit code $loader_status"
    end

    return $loader_status
end

function bootstrap
    set package_manager $argv[1]

    if not functions | string match "p_detect" &> /dev/null
        log "$package_manager is currently unsupported, feature requests and PRs welcome!"

        return 1
    end

    if not p_detect
        functions --erase p_detect

        log "Detect hook failed for $package_mangaer"

        return 1
    end

    if not functions | string match "p_setup" &> /dev/null
        log "Unable to find detect hook function \"p_setup\" when loading $package_manager"

        return 1
    end

    p_setup

    set cached_status $status

    if test $cached_status !=  0
        functions --erase p_detect p_setup

        log "Bootstrapping $package_manager failed with exit code $cached_status"

        return 1
    end

    functions --erase p_detect p_setup

    return 0
end

function process_loaders_from_list
    set names $argv

    log "Processing loaders from list ($names)"

    for name in $names
        set script_path "$P_DIRECTORY/loaders/$name.fish"

        log "Parsing $name ($script_path)"

        if not begin
            loader_exists $script_path
            and loader_runs $script_path
            and bootstrap $name
        end
            log "Skipping..."

            continue
        end

        set P_LOADED $name

        log "Loaded $name!"

        return 0
    end

    return 127
end

function auto_detect_package_manager
    add_log_header

    if not set -q $P_LOADED[1]
        teardown_aliases

        set P_LOADED
    end

    set payload (process_loaders_from_list $P_SUPPORTED_DEVELOPMENT)

    if test $status != 0
        set payload (process_loaders_from_list $P_SUPPORTED_SYSTEM_PACKAGE_MANAGERS)
    end

    add_log_footer

    if test $P_DEBUG = true
        if command -q bat
            bat $P_LOG_FILE
        else
            cat $P_LOG_FILE
        end
    end

    return 0
end

function on_pwd_change --on-variable PWD
    set previously_loaded $P_LOADED

    auto_detect_package_manager

    if test $previously_loaded; and test "$previously_loaded" != "$P_LOADED"
        set name $P_LOADED

        if not set -q P_LOADED[1]
            set name "<none>"
        end

        if test name = "<none>"
            log "Using no aliases..."
        else
            log "Switching to $name aliases..."
        end
    end
end

auto_detect_package_manager
