#!/bin/sh

# Define paths and filenames
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
PID_FILE="$XDG_CACHE_HOME/screenrecord.pid"
STATE_FILE="$XDG_CACHE_HOME/screenrecord.state"

[ -s "$PID_FILE" ] || exit 0

PID=$(cat "$PID_FILE")
ps -p "$PID" >/dev/null 2>&1 || exit 0

if [ -f "$STATE_FILE" ]; then
    case "$(cat "$STATE_FILE")" in
        recording) echo "󰑊 REC" ;;
        *)         echo "● FAILED" ;; # Fallback
    esac
else
    echo "● NO FILE" # STATE_FILE missing
fi
