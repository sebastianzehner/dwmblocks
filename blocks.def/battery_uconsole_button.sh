#!/bin/sh
case "$1" in
    1) battery_output=$(battery energy | sed 's/\x1b\[[0-9;]*m//g')
       notify-send "Battery Status" "$battery_output"
       ;;
    3) battery_output=$(battery time | sed 's/\x1b\[[0-9;]*m//g')
       notify-send "Battery Time" "$battery_output"
       ;;
esac
