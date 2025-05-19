#!/bin/bash
# options="Logout\nReboot\nShutdown"
options="Reboot\nShutdown"
choice=$(echo -e $options | tofi --prompt "Power Menu: ")

case $choice in
    # "Logout") uwsm stop ;;
    "Reboot") systemctl reboot ;;
    "Shutdown") systemctl poweroff ;;
    *) exit 1 ;;  # Если ничего не выбрано, просто выходим
esac
