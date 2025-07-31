#!/usr/bin/env zsh
setopt ERR_EXIT EXTENDED_GLOB PIPE_FAIL

error_exit() {
	print "Error: $1" >&2
	exit 1
}

# 1. Определяем корневой диск
rootdev=$(findmnt -n -o SOURCE /)               || error_exit "Cannot determine root device"
rootdisk=$(lsblk -no PKNAME "$rootdev")         || error_exit "Cannot determine root disk"

# 2. Собираем список съёмных накопителей
get_device_entries() {
	local jq_filter='
		.blockdevices[]
		| .children[]?
		| select(.fstype != null)
		| select(.mountpoint != "/" and .fstype != "swap")
		| select(.pkname != $rootdisk)
		| "/dev/" + .name
			+ " (" + ((.label // .name) | gsub("[^[:print:]]"; "_")) + ")"
			+ " - " + ((.fstype // "unknown") | gsub("[[:space:]\u00A0]+"; " ") | gsub("[^[:print:]]"; ""))
			+ " - " + ((.size / (1024*1024*1024) | floor * 100 / 100) | tostring + "G")
			+ (if .tran == "usb"        then " [USB]"
				elif .tran == "sata"      then " [SATA]"
				elif (.tran == "mmc" or .tran == "sd") then " [CardReader]"
				else " [Other]" end)
			+ (if .mountpoint then " [mounted]" else " [unmounted]" end)
		'

	lsblk -b -f -J -o NAME,LABEL,FSTYPE,MOUNTPOINT,SIZE,TRAN,PKNAME \
		| jq -r --arg rootdisk "$rootdisk" "$jq_filter"
}

entries=$(get_device_entries)
[[ -z $entries ]] && error_exit "No removable devices found"

# 3. Выводим меню
choice=$(print $entries | tofi --prompt-text "Toggle mount:") || exit 0

# 4. Парсим путь (/dev/…)
dev=${choice%% *}   # всё до первого пробела

# 5. Проверяем, что это блок-девайс
[[ $dev == /dev/[a-z]##[0-9]## ]]   || error_exit "Invalid device selection"
[[ -b $dev ]]                      || error_exit "Device $dev not found"

# 6. Узнаём, смонтирован ли
mountpoint=$(lsblk -no MOUNTPOINT $dev) || error_exit "Failed to query mountpoint"
if [[ -n $mountpoint ]]; then
	print "Unmounting $dev..."
	udisksctl unmount -b "$dev" || error_exit "Failed to unmount $dev"
	print "✅ Unmounted successfully"
else
	print "Mounting $dev..."
	udisksctl mount -b "$dev"   || error_exit "Failed to mount $dev"
	print "✅ Mounted successfully"
fi
