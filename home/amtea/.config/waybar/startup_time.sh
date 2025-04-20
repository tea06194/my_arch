#!/bin/bash

log=$(journalctl -b | grep -m1 'systemd\[1\]: Startup finished in')
[[ -z "$log" ]] && { echo '{"class": "startup_grey"}'; exit 0; }

time_str=$(echo "$log" | cut -d'=' -f2 | grep -oE '[0-9]+(\.[0-9]+)?')

if ! [[ "$time_str" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    echo '{"class": "startup_grey"}'
    exit 0
fi

case $(printf "%.0f" "$time_str") in
    [0-9]|1[0-1]) echo '{"class": "startup_green"}' ;;
    12) echo '{"class": "startup_yellow"}' ;;
    *) echo '{"class": "startup_red"}' ;;
esac

