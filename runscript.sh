#!/bin/bash

# kill any existing socat or java processes, so we can run this repeatedly
pgrep socat | xargs kill
pgrep java | xargs kill

xvfb-daemon-run /opt/IBController/Scripts/DisplayBannerAndLaunch.sh &
# Tail latest in log dir
sleep 1
tail -f $(find $LOG_PATH -maxdepth 1 -type f -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d' ' -f 2-) &

# Give enough time for a connection before trying to expose on 0.0.0.0:4003
sleep 30
echo "Forking :::4001 onto 0.0.0.0:4003\n"
socat TCP-LISTEN:4003,fork TCP:127.0.0.1:4001
