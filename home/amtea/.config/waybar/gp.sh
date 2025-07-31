#!/bin/zsh

setopt PIPE_FAIL

# Get GPU utilization and memory usage
gpu_data=$(nvidia-smi --query-gpu=utilization.gpu,memory.used --format=csv,noheader,nounits) || exit 1

# Parse data using zsh parameter expansion
IFS=',' read -r gpu_util memory_used <<< "${gpu_data// /}"

# Convert memory from MB to GB using zsh arithmetic
memory_gb=$((memory_used / 1024.0))

# Format output using zsh printf
printf "gpu:%s%%|%.1fGB " "$gpu_util" "$memory_gb"
