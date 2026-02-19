#!/usr/bin/env bash
SERVICE_NAME="backup-projects.service"

sudo ln -fs $(realpath $SERVICE_NAME) /usr/lib/systemd/system/$SERVICE_NAME
sudo ln -fs $(realpath $SERVICE_NAME) /etc/systemd/system/$SERVICE_NAME
sudo systemctl enable --now ydotoold
