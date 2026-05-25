#!/usr/bin/env bash
# https://stackoverflow.com/a/246128
SCRIPT_DIRECTORY=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

sudo install --directory --owner $USER --group $USER --mode 700 /mnt/backup
sudo install --directory --owner $USER --group $USER --mode 707 /mnt/games
sudo install --directory --owner $USER --group $USER --mode 707 /mnt/hdd
sudo cp -f /etc/fstab "$SCRIPT_DIRECTORY/fstab.bak"
sudo cp -f "$SCRIPT_DIRECTORY/fstab" /etc/fstab
sudo systemctl daemon-reload
