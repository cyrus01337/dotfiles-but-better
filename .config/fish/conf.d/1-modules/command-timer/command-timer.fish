#!/usr/bin/env fish
set COMMAND_TIMER_FILE (status --current-filename)
set COMMAND_TIMER_DIRECTORY (dirname $COMMAND_TIMER_FILE)
set COMMAND_TIMER_ENVIRONMENT_FILEPATH "$COMMAND_TIMER_DIRECTORY/environment.toml"

if not command -q custom_command_timer &> /dev/null; and command -q qq &> /dev/null; and not set -q DISABLE_COMMAND_TIMER; and test -f $COMMAND_TIMER_ENVIRONMENT_FILEPATH; or test "$DISABLE_COMMAND_TIMER" != true
    function read_environment
        qq $argv[1] $COMMAND_TIMER_ENVIRONMENT_FILEPATH --monochrome-output --raw-output
    end

    function partially_humanise_time
        set ONE_SECOND 1000
        set ONE_MINUTE (math $ONE_SECOND \* 60)
        set ONE_HOUR (math $ONE_MINUTE \* 60)

        set time_ $argv[1]

        if test "$time_" -lt $ONE_MINUTE
            set seconds (math floor\($time_ / $ONE_SECOND\))
            set addendum ""

            if test "$seconds" -gt 1
                set addendum "s"
            end

            echo "$seconds second$addendum"
        else if test "$time_" -lt $ONE_HOUR
            set minutes (math floor\($time_ / $ONE_MINUTE\))
            set seconds (math floor\($time_ % $ONE_MINUTE\) / $ONE_SECOND)
            set minutes_addendum ""
            set seconds_addendum ""

            if test "$minutes" -gt 1
                set minutes_addendum "s"
            end

            if test "$seconds" != 1
                set seconds_addendum "s"
            end

            echo "$minutes minute$minutes_addendum and $seconds second$seconds_addendum"
        else
            set hours (math floor\($time_ / $ONE_HOUR\))
            set minutes (math floor\($time_ % $ONE_HOUR\) / $ONE_MINUTE)
            set hours_addendum ""
            set minutes_addendum ""

            if test "$hours" -gt 1

                set hours_addendum "s"
            end

            if test "$minutes" != 1
                set minutes_addendum "s"
            end

            echo "$hours hour$hours_addendum and $minutes minute$minutes_addendum"
        end
    end

    function notify_phone
        # Normally these would be only initialised once but if the environment
        # variables ever change for whatever reason, I want those changes to
        # propagate immediately to avoid reloading my shell over minor changes
        set NOTIFICATION_SERVER_DOMAIN (read_environment '.notification_server_domain')
        set NTFY_USER_TOKEN (read_environment '.ntfy_user_token')

        set full_command $argv[1]
        set command_duration $argv[2]
        set command_status $argv[3]
        set pretty_command_duration (partially_humanise_time $command_duration)
        set success_message ""
        set failure_message ""
        set title ""

        if test "$command_status" = 0
            set success_message "successfully "
            set title "Command ran successfully"
        else
            set failure_message " with exit code \\\\"$command_status\\\\""
            set title "Command failed"
        end

        set message (printf '\\\\"%s\\\\" %sran for %s%s' $full_command $success_message $pretty_command_duration $failure_message)
        set payload (printf '{"topic": "notify-phone", "title": "%s", "message": "%s"}' $title $message)

        curl \
            --silent \
            --data $payload \
            --user ":$NTFY_USER_TOKEN" \
            "https://$NOTIFICATION_SERVER_DOMAIN" \
            1> /dev/null
    end

    function is_ignored
        set -a IGNORED_COMPONENTS (read_environment ".ignored_components[]")

        set full_command $argv

        for component in $IGNORED_COMPONENTS
            if string match -e $component $full_command 1> /dev/null
                return 0
            end
        end

        return 1
    end

    function command_timer --on-event fish_postexec
        set full_command $argv

        if is_ignored $full_command
            return 1
        end

        set MINIMUM_NOTIFICATION_DURATION (read_environment '.minimum_notification_duration')

        set cached_status $status

        if test $CMD_DURATION -ge $MINIMUM_NOTIFICATION_DURATION
            notify_phone "$argv" "$CMD_DURATION" "$cached_status"
        end
    end
end
