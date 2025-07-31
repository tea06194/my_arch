#!/bin/zsh
setopt PIPE_FAIL

# Get active connections and filter for VPN using zsh pattern matching
active_connections=$(nmcli connection show --active) || exit 1

# Use zsh parameter expansion and pattern matching
if [[ $active_connections == *vpn* ]]; then
	# Extract VPN name using zsh array features
	vpn_lines=(${(f)"$(print -l ${(f)active_connections} | grep vpn)"})
	vpn_name=${${=vpn_lines[1]}[1]}  # Get first word of first VPN line

	# Use here document for cleaner JSON formatting
	cat <<-EOF
	{"text": "🔒", "class": "connected", "tooltip": "VPN Connected: $vpn_name"}
	EOF
else
	cat <<-EOF
	{"text": "🔓", "class": "disconnected", "tooltip": "VPN Disconnected"}
	EOF
fi
