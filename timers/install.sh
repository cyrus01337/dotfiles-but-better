#!/usr/bin/env bash
for timer in *.timer; do
    sudo ln -s $(realpath $timer) /usr/lib/systemd/system/$(basename $timer)
    sudo ln -s $(realpath $timer) /etc/systemd/system/$(basename $timer)
done
