#!/bin/bash

if nmcli connection show --active | grep -q vpn; then
	VPN_NAME=$(nmcli connection show --active | grep vpn | awk '{print $1}')
	echo '{"text": "🔒", "class": "connected", "tooltip": "VPN Connected: '$VPN_NAME'"}'
else
	echo '{"text": "🔓", "class": "disconnected", "tooltip": "VPN Disconnected"}'
fi
