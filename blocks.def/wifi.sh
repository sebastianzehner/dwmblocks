#!/bin/sh

LOCKFILE="/tmp/wifi_status.lock"

# if lockfile exists, assume wifi status cannot be determined
if [ -e "$LOCKFILE" ]; then
    echo "󰤫"
else
    # try to get Wi-Fi status with a timeout
    OUTPUT=$(timeout 5 wifi 2>/dev/null)

    # if output is empty, show fallback icon
    if [ -z "$OUTPUT" ]; then
        echo "󰤫"
    else
        echo "$OUTPUT"
    fi
fi
