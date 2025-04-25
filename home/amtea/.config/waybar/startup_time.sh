#!/bin/bash

log=$(journalctl -b | grep -m1 'systemd\[1\]: Startup finished in')
[[ -z "$log" ]] && { echo '{"text": "N/A", "class": "startup_gray"}'; exit 0; }

time_str=$(echo "$log" | cut -d'=' -f2 | grep -oE '[0-9]+(\.[0-9]+)?')

if ! [[ "$time_str" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    echo '{"text": "N/A", "class": "startup_gray"}'
    exit 0
fi

time_float=$(awk "BEGIN {print $time_str}")

if (( $(awk "BEGIN {print ($time_float > 0 && $time_float <= 12)}") )); then
    class="startup_green"
elif (( $(awk "BEGIN {print ($time_float > 12 && $time_float <= 13)}") )); then
    class="startup_yellow"
else
    class="startup_red"
fi

echo "{\"text\": \"${time_str}s\", \"class\": \"${class}\"}"

