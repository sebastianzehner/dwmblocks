#!/bin/sh
# Shows the Bridge Cast's headphone level via bridgemix-headless's REST API.
# Silent when the API isn't reachable, so dwmblocks omits this segment then.

API="http://127.0.0.1:8765/api/v1"

status="$(curl -s -m 1 "$API/status")" || exit 0
[ -n "$status" ] || exit 0

connected="$(echo "$status" | grep -o '"connected":true')"
[ -n "$connected" ] || exit 0

state="$(curl -s -m 1 "$API/state")" || exit 0
phones_vol="$(echo "$state" | grep -o '"phones_vol":[0-9]*' | cut -d: -f2)"
mute_phones="$(echo "$state" | grep -o '"mute_phones_out":[0-9]*' | cut -d: -f2)"
[ -n "$phones_vol" ] || exit 0

pct="$phones_vol" # already percent-scaled: 100 = nominal, up to 127 = boost

if [ "$mute_phones" = "0" ] || [ "$pct" -eq 0 ]; then
  ICON="\x0c󰟎 \x0b" # muted or 0%, red
elif [ "$pct" -ge 121 ]; then
  ICON="\x0c󰋋 \x0b" # red, near max
elif [ "$pct" -ge 111 ]; then
  ICON="\x0e󰋋 \x0b" # yellow, boosted
else
  ICON="\x0d󰋋 \x0b" # green, normal
fi

printf "%b%s%%\n" "$ICON" "$pct"
