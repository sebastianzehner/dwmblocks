#!/bin/sh

case "$1" in
		1) playerctl play-pause ;;
		2) FORMAT_FILE="/tmp/dwmblocks_mus_format"
		   FORMAT=$(cat "$FORMAT_FILE" 2>/dev/null)
		   echo $((1 - FORMAT)) > "$FORMAT_FILE"
		   sigdwmblocks 7
		   ;;
		3) playerctl stop ;;
		4) playerctl position 5- ;;
		5) playerctl position 5+ ;;
esac
