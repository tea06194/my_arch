#!/bin/bash
# nvidia-gpu-status.sh

gpu_utilization=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
mem_used=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits)

echo "gpu: ${gpu_utilization}%|$(awk -v used="$mem_used" 'BEGIN { printf "%.2f", (used / 1024)}')GB"

