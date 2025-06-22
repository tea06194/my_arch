#!/usr/bin/env bash

USER=/home/amtea
USER_BACKUP=/home/amtea/my_arch/home/amtea
SYSTEM_SERVICES_BACKUP=/home/amtea/my_arch/etc/systemd/system

clean_and_create_dir() {
    local dir="$1"
    if [ -d "$dir" ]; then
        rm -rf "$dir"
    fi
    mkdir -p "$dir"
}



clean_and_create_dir "$USER_BACKUP"
clean_and_create_dir "$SYSTEM_SERVICES_BACKUP" 

mkdir -p "$USER_BACKUP/packages/"
mkdir -p "$USER_BACKUP/.config/"
mkdir -p "$USER_BACKUP/.local/share/"

pacman -Qqe > $USER_BACKUP/packages/packages.txt
pacman -Qqm > $USER_BACKUP/packages/aur_packages.txt

cp -ruv $USER/.bash_profile $USER_BACKUP/
cp -ruv $USER/.bashrc $USER_BACKUP/
cp -ruv $USER/.makepkg.conf $USER_BACKUP/

find "$USER/ManualPackages" -type f -name PKGBUILD | while read -r pkgbuild_path; do
    relative_path="${pkgbuild_path#$USER/}"
    destination_dir="$USER_BACKUP/$(dirname "$relative_path")"
    mkdir -p "$destination_dir"
    cp -v "$pkgbuild_path" "$destination_dir/"
done

cp -rv $USER/.config/autostart $USER_BACKUP/.config/
cp -rv $USER/.config/audacious $USER_BACKUP/.config/
cp -rv $USER/.config/environment.d $USER_BACKUP/.config/
cp -rv $USER/.config/hypr $USER_BACKUP/.config/
cp -rv $USER/.config/kitty $USER_BACKUP/.config/
cp -rv $USER/.config/nvim $USER_BACKUP/.config/
cp -rv $USER/.config/nvm $USER_BACKUP/.config/
cp -rv $USER/.config/systemd $USER_BACKUP/.config/
cp -rv $USER/.config/tofi $USER_BACKUP/.config/
cp -rv $USER/.config/waybar $USER_BACKUP/.config/
cp -rv $USER/.config/yazi $USER_BACKUP/.config/
cp -rv $USER/.config/pwr.sh $USER_BACKUP/.config/
cp -rv $USER/.config/mimeapps.list $USER_BACKUP/.config/

cp -rv $USER/.local/share/fonts $USER_BACKUP/.local/share/
cp -rv $USER/.local/share/applications $USER_BACKUP/.local/share/

cp -rv /etc/systemd/system/numlock.service $SYSTEM_SERVICES_BACKUP/
cp -rv /etc/systemd/system/getty@tty1.service.d $SYSTEM_SERVICES_BACKUP/
