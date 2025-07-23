#!/bin/sh
case "$1" in
    1) exec "$TERMINAL" watch -n 10 -t nvidia-smi ;;
    2) exec "$TERMINAL" htop ;;
    3) exec "$TERMINAL" btop ;;
esac
