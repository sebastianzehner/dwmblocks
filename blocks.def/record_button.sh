#!/bin/sh

# Define paths and filenames
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
PID_FILE="$XDG_CACHE_HOME/screenrecord.pid"

[ -s "$PID_FILE" ] || exit 0

case "$1" in
    1)  record stop ;;
esac
