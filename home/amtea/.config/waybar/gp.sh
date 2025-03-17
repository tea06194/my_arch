#!/bin/bash
# nvidia-gpu-status.sh

gpu_utilization=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
mem_used=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits)
# mem_total=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits)
# mem_used_percent=$(awk -v used="$mem_used" -v total="$mem_total" 'BEGIN { printf "%d", (used / total) * 100 }')

echo "gpu: ${gpu_utilization}% vram: $(awk -v used="$mem_used" 'BEGIN { printf "%.2f", (used / 1024)}')GB"

