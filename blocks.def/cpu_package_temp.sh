#!/bin/sh

ICONn="\x0d \x0b" # icon for normal temperatures
ICONc="\x0c \x0b" # icon for critical temperatures

crit=70 # critical temperature

# Read CPU Package temperature from sensors output
# Remove the "+" and "°C" symbols, convert to integer
temp=$(sensors | awk '/^CPU Package:/ {gsub(/\+|°C/, "", $3); print int($3)}')

# Print temperature with appropriate icon depending on threshold
if [ "$temp" -lt "$crit" ]; then
    printf "$ICONn%s°C\n" "$temp"
else
    printf "$ICONc%s°C\n" "$temp"
fi
