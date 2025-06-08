#!/bin/sh
case "$1" in
    1) exec st -e htop -s PERCENT_CPU ;;
    2) exec st htop ;;
    3) exec st -e htop -s PERCENT_MEM ;;
esac
