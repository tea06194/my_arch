#!/usr/bin/env bash
USER=/home/amtea
USER_BACKUP=/home/amtea/my_arch/home/amtea
SYSTEM_SERVICES_BACKUP=/home/amtea/my_arch/etc/systemd/system

clean_and_create_dir() {
	local dir="$1"
	local use_sudo="$2"
	
	if [ "$use_sudo" = "sudo" ]; then
		if [ -d "$dir" ]; then
			sudo rm -rf "$dir"
		fi
		sudo mkdir -p "$dir"
	else
		if [ -d "$dir" ]; then
			rm -rf "$dir"
		fi
		mkdir -p "$dir"
	fi
}

clean_and_create_dir "$USER_BACKUP"
clean_and_create_dir "$SYSTEM_SERVICES_BACKUP" "sudo"
mkdir -p "$USER_BACKUP/packages/"
mkdir -p "$USER_BACKUP/.config/"
mkdir -p "$USER_BACKUP/.local/share/"

pacman -Qqe >$USER_BACKUP/packages/packages.txt
pacman -Qqm >$USER_BACKUP/packages/aur_packages.txt

copy_verbose() {
	local src="$1"
	local dest="$2"
	local flags="$3"
	local use_sudo="$4"
	
	if [ "$use_sudo" = "sudo" ]; then
		if sudo cp $flags "$src" "$dest"; then
			echo "✅ Successfully copied: $src"
		else
			echo "❗ Failed to copy: $src"
		fi
	else
		if cp $flags "$src" "$dest"; then
			echo "✅ Successfully copied: $src"
		else
			echo "❗ Failed to copy: $src"
		fi
	fi
}

copy_verbose "$USER/.bash_profile" "$USER_BACKUP/" "-ruv"
copy_verbose "$USER/.bashrc" "$USER_BACKUP/" "-ruv"
copy_verbose "$USER/.makepkg.conf" "$USER_BACKUP/" "-ruv"

find "$USER/ManualPackages" -type f -name PKGBUILD | while read -r pkgbuild_path; do
	relative_path="${pkgbuild_path#$USER/}"
	destination_dir="$USER_BACKUP/$(dirname "$relative_path")"
	mkdir -p "$destination_dir"
	cp -v "$pkgbuild_path" "$destination_dir/"
done

copy_verbose "$USER/.config/autostart" "$USER_BACKUP/.config/" "-rv"
copy_verbose "$USER/.config/audacious" "$USER_BACKUP/.config/" "-rv"
copy_verbose "$USER/.config/environment.d" "$USER_BACKUP/.config/" "-rv"
copy_verbose "$USER/.config/hypr" "$USER_BACKUP/.config/" "-rv"
copy_verbose "$USER/.config/kitty" "$USER_BACKUP/.config/" "-rv"
copy_verbose "$USER/.config/mako" "$USER_BACKUP/.config/" "-rv"
copy_verbose "$USER/.config/nvim" "$USER_BACKUP/.config/" "-rv"
copy_verbose "$USER/.config/nvm" "$USER_BACKUP/.config/" "-rv"
copy_verbose "$USER/.config/systemd" "$USER_BACKUP/.config/" "-rv"
copy_verbose "$USER/.config/tofi" "$USER_BACKUP/.config/" "-rv"
copy_verbose "$USER/.config/waybar" "$USER_BACKUP/.config/" "-rv"
copy_verbose "$USER/.config/yazi" "$USER_BACKUP/.config/" "-rv"
copy_verbose "$USER/.config/pwr.sh" "$USER_BACKUP/.config/" "-rv"
copy_verbose "$USER/.config/mimeapps.list" "$USER_BACKUP/.config/" "-rv"
copy_verbose "$USER/.local/share/fonts" "$USER_BACKUP/.local/share/" "-rv"
copy_verbose "$USER/.local/share/applications" "$USER_BACKUP/.local/share/" "-rv"

copy_verbose "/etc/systemd/system/numlock.service" "$SYSTEM_SERVICES_BACKUP/" "-rv" "sudo"
copy_verbose "/etc/systemd/system/getty@tty1.service.d" "$SYSTEM_SERVICES_BACKUP/" "-rv" "sudo"
