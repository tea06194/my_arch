#!/bin/zsh
setopt PIPE_FAIL

readonly VPN_NAME="samie.main"

if nmcli connection show --active | grep -q "$VPN_NAME"; then
	nmcli connection down "$VPN_NAME"
else
	nmcli connection up "$VPN_NAME" || notify-send "VPN Error" "Failed to connect to $VPN_NAME" -i dialog-error
fi

# Use more specific signal instead of generic RTMIN+10
pkill -SIGUSR1 waybar 2>/dev/null || pkill -RTMIN+10 waybar
