#!/usr/bin/env bash
SERVICE_NAME="notification-server.service"

docker compose up -d
sudo ln -s $(realpath $SERVICE_NAME) /usr/lib/systemd/system/$SERVICE_NAME
sudo ln -s $(realpath $SERVICE_NAME) /etc/systemd/system/$SERVICE_NAME
sudo systemctl enable --now $SERVICE_NAME
