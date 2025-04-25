#!/usr/bin/env bash

USER=/home/amtea
USER_BACKUP=/home/amtea/my_arch/home/amtea
SYSTEM_SERVICES_BACKUP=/home/amtea/my_arch/etc/systemd/system

mkdir -p $USER_BACKUP/packages/
mkdir -p $USER_BACKUP/.config/
mkdir -p $USER_BACKUP/.local/share/
mkdir -p $SYSTEM_SERVICES_BACKUP/

pacman -Qqe > $USER_BACKUP/packages/packages.txt
pacman -Qqm > $USER_BACKUP/packages/aur_packages.txt

cp -ruv $USER/.bash_profile $USER_BACKUP/
cp -ruv $USER/.bashrc $USER_BACKUP/

cp -ruv $USER/.config/autostart $USER_BACKUP/.config/
cp -ruv $USER/.config/hypr $USER_BACKUP/.config/
cp -ruv $USER/.config/kitty $USER_BACKUP/.config/
cp -ruv $USER/.config/nvim $USER_BACKUP/.config/
cp -ruv $USER/.config/systemd $USER_BACKUP/.config/
cp -ruv $USER/.config/tofi $USER_BACKUP/.config/
cp -ruv $USER/.config/waybar $USER_BACKUP/.config/
cp -ruv $USER/.config/yazi $USER_BACKUP/.config/
cp -ruv $USER/.config/pwr.sh $USER_BACKUP/.config/

cp -ruv $USER/.local/share/fonts $USER_BACKUP/.local/share/
cp -ruv $USER/.local/share/applications $USER_BACKUP/.local/share/

cp -ruv /etc/systemd/system/numlock.service $SYSTEM_SERVICES_BACKUP/
cp -ruv /etc/systemd/system/getty@tty1.service.d $SYSTEM_SERVICES_BACKUP/
