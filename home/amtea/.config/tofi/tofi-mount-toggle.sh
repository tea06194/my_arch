#!/usr/bin/env bash

rootdev=$(findmnt -n -o SOURCE /)               # /dev/sda3
rootdisk=$(lsblk -no PKNAME "$rootdev")         # sda

# Собрать список безопасных устройств
entries=$(lsblk -b -f -J -o NAME,LABEL,FSTYPE,MOUNTPOINT,SIZE,TRAN,PKNAME | jq -r --arg rootdisk "$rootdisk" '
  .blockdevices[]
  | .children[]?
  | select(.fstype != null)
  | select(.mountpoint != "/" and .fstype != "swap")
  | select(.pkname != $rootdisk)
  | "/dev/" + .name
    + " (" + ((.label // .name | gsub("[^[:print:]]"; "_"))) + ")"
    + " - " + ((.fstype // "unknown") | gsub("[[:space:]\u00A0]+"; " ") | gsub("[^[:print:]]"; ""))
    + " - " + ((.size | tonumber / (1024*1024*1024) * 100 | floor / 100) | tostring + "G")
    + (if .tran == "usb" then " [USB]"
       elif .tran == "sata" then " [SATA]"
       elif .tran == "mmc" or .tran == "sd" then " [CardReader]"
       else " [Other]" end)
    + (if .mountpoint then " [mounted]" else " [unmounted]" end)
')

# Показать меню
choice=$(echo "$entries" | tofi --prompt-text "Toggle mount:")

# Обработать выбор
dev=$(echo "$choice" | grep -oE '/dev/[a-z]{3}[0-9]+')
[ -z "$dev" ] && exit 0

if mountpoint=$(lsblk -no MOUNTPOINT "$dev" | grep -v '^$'); then
  udisksctl unmount -b "$dev"
else
  udisksctl mount -b "$dev"
fi
