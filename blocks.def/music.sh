#!/bin/sh

# List of media players to check, in order of priority
PLAYERS="mpd brave mpv"

# Toggle format between:
# 0 = artist - title
# 1 = album  - title
FORMAT_FILE="/tmp/dwmblocks_mus_format"
[ ! -f "$FORMAT_FILE" ] && echo "0" > "$FORMAT_FILE"
read -r FORMAT < "$FORMAT_FILE"

# Select the metadata format string based on FORMAT value
if [ "$FORMAT" -eq 0 ]; then
	META="{{ trunc(artist,17) }} - {{ trunc(title,17) }}"
else
	META="{{ trunc(album,17) }} - {{ trunc(title,17) }}"
fi

# Loop through players and display info for the first active one
for PLAYER in $PLAYERS; do
	# Query playback status (Playing, Paused, or other)
	STATUS=$(timeout 1s playerctl --player="$PLAYER" status 2>/dev/null) || continue

	case "$STATUS" in
		  Playing) ICON="▶ " ;;
		  Paused)  ICON="󰏤 " ;;
		  *) continue ;;  # Skip players that are stopped or inaccessible
	esac

	# Fetch metadata using the selected format
	TEXT=$(timeout 1s playerctl metadata --player="$PLAYER" --format="$META" 2>/dev/null)

	# If metadata is available, print it and exit
	[ -n "$TEXT" ] && printf "%s%s\n" "$ICON" "$TEXT" && exit 0
done
