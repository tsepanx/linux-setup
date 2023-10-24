#!/bin/bash

YML_PATH="/home/pi/linux-setup/rpi/scripts/docker-compose.yml"
DELAY=15

echo "Sleeping for $DELAY secs..."
/bin/sleep $DELAY

echo "=== BEFORE ==="
docker ps

docker compose -f $YML_PATH restart

echo "=== AFTER ==="
docker ps
