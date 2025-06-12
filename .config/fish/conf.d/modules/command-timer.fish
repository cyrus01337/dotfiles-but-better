#!/usr/bin/env fish
set CUSTOM_COMMAND_TIMER_MINIMUM_DURATION_IN_MILLISECONDS 2000
set -a CUSTOM_COMMAND_TIMER_NOTIFY_PHONE_COMMAND "$__fish_config_dir/lib/notify-phone.py"

if not command -q custom_command_timer
    function custom_command_timer --on-event fish_postexec
        if test $CMD_DURATION -ge $CUSTOM_COMMAND_TIMER_MINIMUM_DURATION_IN_MILLISECONDS
            python3 $CUSTOM_COMMAND_TIMER_NOTIFY_PHONE_COMMAND "$argv" "$status"
        end
    end
end
