#!/usr/bin/env python3
import datetime
import pathlib
import re
import sys
import tomllib

import humanize
import requests

CURRENT_FILE = pathlib.Path(__file__)
ENVIRONMENT_FILE = CURRENT_FILE.parent / "environment.toml"
URL_REGEX = re.compile(r"https://discord\.com/api/webhooks/[0-9]{16,19}/[a-zA-Z0-9_]+")


class ConfigurationError(Exception):
    pass


def main():
    with ENVIRONMENT_FILE.open("rb") as file_header:
        environment = tomllib.load(file_header)
        webhook_url = environment["WEBHOOK_URL"]

        if not URL_REGEX.match(webhook_url):
            raise ConfigurationError(
                f'WEBHOOK_URL "{webhook_url}" does not match the following regex: {URL_REGEX.pattern}'
            )

        command, duration, status = sys.argv[1:]

        if (ignored_commands_found := environment.get("IGNORED_COMMANDS", None)) and (
            _starts_with_ignored_command := any(
                command.startswith(ignored_command)
                for ignored_command in ignored_commands_found
            )
        ):
            exit(1)

        formatted_duration = humanize.naturaldelta(
            datetime.timedelta(milliseconds=int(duration))
        )
        json = {
            "content": f"`{command}` ran for {formatted_duration} with exit code `{status}`",
        }

        requests.post(webhook_url, json=json)


if __name__ == "__main__":
    main()
