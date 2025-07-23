#!/bin/sh
ICONc="\x0b󱛡 \x0b"
#ICONc="\x0b󱨰 \x0b"
#ICONt="\x0b \x0b"
printf "$ICONc%s $ICONt%s" "$(date '+%d %b')" "$(date +%R)"
