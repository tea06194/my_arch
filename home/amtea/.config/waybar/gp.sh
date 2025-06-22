#!/bin/bash
# nvidia-gpu-status.sh

nvidia-smi --query-gpu=utilization.gpu,memory.used --format=csv,noheader,nounits |
	awk -F',' '{
    gsub(/ /, "", $1); gsub(/ /, "", $2)
    printf "gpu:%s%%|%.1fGB ", $1, ($2/1024)
}'
