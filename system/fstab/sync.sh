#!/usr/bin/env bash
# https://stackoverflow.com/a/246128
SCRIPT_DIRECTORY=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

sudo cp -f /etc/fstab "$SCRIPT_DIRECTORY/fstab.bak"
sudo cp -f "$SCRIPT_DIRECTORY/fstab" /etc/fstab
sudo systemctl daemon-reload
