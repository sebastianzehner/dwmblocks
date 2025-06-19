#!/bin/sh
case "$1" in
    1) audio_volume mute ;;
    3) audio_volume set 50 ;;
    4) audio_volume up ;;
    5) audio_volume down ;;
esac
