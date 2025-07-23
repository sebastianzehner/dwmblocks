#!/bin/sh

# Query used and total GPU memory (in MB) and temperature (in °C)
out=$(nvidia-smi --query-gpu=memory.used,memory.total,temperature.gpu \
    --format=csv,noheader,nounits | head -n 1)

# Parse CSV output
IFS=',' read -r mem_used mem_total temp <<< "$out"

# Strip all whitespace from temp
temp="${temp//[[:space:]]/}"

# Convert memory values from MB to GiB
gb_used=$(awk "BEGIN {printf \"%.1f\", $mem_used / 1024}")
gb_total=$(awk "BEGIN {printf \"%.1f\", $mem_total / 1024}")
used_int=${gb_used%.*}  # Integer part for comparisons

# Determine temperature icon color
if [ "$temp" -ge 75 ]; then
    TEMP_ICON="\x0c󰾲 \x0b"  # red
elif [ "$temp" -ge 65 ]; then
    TEMP_ICON="\x0e󰾲 \x0b"  # yellow
else
    TEMP_ICON="\x0d󰾲 \x0b"  # green
fi

# Determine VRAM icon color
if [ "$used_int" -ge 23 ]; then
    VRAM_ICON="\x0c󰾲 \x0b"  # red
elif [ "$used_int" -ge 12 ]; then
    VRAM_ICON="\x0e󰾲 \x0b"  # yellow
else
    VRAM_ICON="\x0d󰾲 \x0b"  # green
fi

# Print formatted output for dwmblocks
printf "${TEMP_ICON}${temp}°C ${VRAM_ICON}${gb_used}G/${gb_total}G"

