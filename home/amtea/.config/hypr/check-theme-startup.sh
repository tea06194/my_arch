#!/usr/bin/env zsh

# Read last theme (light or dark)
THEME=$(<~/.config/theme/current_theme)

if [[ "$THEME" == "dark" ]]; then
	gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
	gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
else
	gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
	gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
fi
