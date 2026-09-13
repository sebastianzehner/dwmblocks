#!/bin/sh
# Toggles Bridge Cast headphone mute via bridgemix-headless's REST API.
# phones_vol is the physical knob and read-only over the API; mute is the only control here.

API="http://127.0.0.1:8765/api/v1/parameters/mute_phones_out"

case "$1" in
  1)
    current="$(curl -s -m 1 "$API" | grep -o '"value":[0-9]*' | cut -d: -f2)"
    [ -n "$current" ] || exit 0
    [ "$current" = "0" ] && new=1 || new=0
    curl -s -m 1 -X PUT "$API" -H 'Content-Type: application/json' -d "{\"value\": $new}" >/dev/null
    sigdwmblocks 3
    ;;
esac
