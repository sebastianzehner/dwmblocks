#!/bin/sh
# (for pipewire users)
# This script parses the output of `pactl list sinks' to find volume and mute
# status of the default audio sink and whether headphones are plugged in or not.
# Modified headphone detection with cm5 and simple-audio-card driver using amixer.
# Also see ../daemons/pulse_daemon.sh

# Bridge Cast's main sink is an "Internal" PipeWire node, use wpctl instead.
bridge_id="$(wpctl status | awk '
    /Sinks:/   { in_sinks=1; next }
    /Sources:/ { in_sinks=0 }
    in_sinks && /BRIDGE CAST V2 0/ {
        match($0, /[0-9]+/)
        print substr($0, RSTART, RLENGTH)
        exit
    }
')"

if [ -n "$bridge_id" ]; then
  ICONsn="\x0d󰕾 \x0b" # not muted
  ICONsm="\x0c󰖁 \x0b" # muted

  bridge_vol_raw="$(wpctl get-volume "$bridge_id")"
  bridge_frac="$(echo "$bridge_vol_raw" | awk '{print $2}')"
  bridge_pct="$(awk -v v="$bridge_frac" 'BEGIN{printf "%d%%", v*100+0.5}')"

  if echo "$bridge_vol_raw" | grep -q MUTED; then
    printf "%b%s\n" "$ICONsm" "$bridge_pct"
  else
    printf "%b%s\n" "$ICONsn" "$bridge_pct"
  fi
  exit
fi

# Detect default sink
sink="$(pactl info | awk '$1 == "Default" && $2 == "Sink:" {print $3}')"
[ -n "$sink" ] || exit

# Get device model from device tree or fallback to unknown
model=$(cat /proc/device-tree/model 2>/dev/null || echo "unknown")

if echo "$model" | grep -qi "Compute Module 5"; then
  # On CM5 / RP5 detect headphone plugged state via amixer (card 2)
  headphone_plugged=$(amixer -c 2 get 'Headphones' | awk '
        /Mono: Playback \[on\]/ { print 1; exit }
        END { if (NR==0) print 0 }')
else
  # No override for other devices
  headphone_plugged=""
fi

# Parse pactl output with possible CM5 headphone override
pactl list sinks | awk -v sink="$sink" -v cm5_headphone="$headphone_plugged" '
    BEGIN {
        ICONsn = "\x0d󰕾 \x0b" # headphone unplugged, not muted
        ICONsm = "\x0c󰖁 \x0b" # headphone unplugged, muted
        ICONhn = "\x0d󰋋 \x0b" # headphone plugged in, not muted
        ICONhm = "\x0c󰟎 \x0b" # headphone plugged in, muted
    }
    f {
        if ($1 == "Mute:" && $2 == "yes") {
            m = 1
        } else if ($1 == "Volume:") {
            if ($3 == $10) {
                vb = $5
            } else {
                vl = $5
                vr = $12
            }
        } else if ($1 == "Active" && $2 == "Port:") {
            # Use pactl detection only if no CM5 override
            if (cm5_headphone == "")
                if (tolower($3) ~ /headphone/)
                    h = 1
            exit
        }
        next
    }
    $1 == "Name:" && $2 == sink {
        f = 1
    }
    END {
        if (f) {
            # Override headphone status if on CM5
            if (cm5_headphone != "") {
                h = (cm5_headphone == 1)
            }
            printf "%s", h ? (m ? ICONhm : ICONhn) : (m ? ICONsm : ICONsn)
            if (vb)
                print vb
            else
                printf "L%s R%s\n", vl, vr
        }
    }
'
