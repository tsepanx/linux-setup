#!/bin/bash

WG_SERVER_IP="10.66.66.1"

ping -c 4 $WG_SERVER_IP

# Check the exit status of the ping command
if [ $? -ne 0 ]; then
        echo "=== Restarting wg service... ==="
        systemctl restart wg-quick@do.service
else
        echo "=== Server is accessible ==="
fi

