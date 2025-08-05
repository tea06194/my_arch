#!/bin/zsh
# Modern power menu script using zsh arrays

# Define power options using zsh array
typeset -a power_options=(
	"Reboot"
	"Shutdown"
	# "Logout"  # Uncomment if needed
)

# Join array elements with newlines using zsh parameter expansion
menu=${(j:\n:)power_options}

# Get user choice
choice=$(print "$menu" | tofi --prompt "Power Menu: ")

# Use associative array for cleaner action mapping
typeset -A power_actions=(
	[Reboot]="systemctl reboot"
	[Shutdown]="systemctl poweroff"
	# [Logout]="uwsm stop"
)

# Execute action if valid choice was made
if [[ -n "$power_actions[$choice]" ]]; then
	eval "$power_actions[$choice]"
else
	exit 1  # Invalid choice or cancelled
fi
