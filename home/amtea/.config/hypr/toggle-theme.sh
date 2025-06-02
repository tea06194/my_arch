#!/usr/bin/env bash

CURRENT=$(gsettings get org.gnome.desktop.interface color-scheme)
if [[ "$CURRENT" == "'prefer-dark'" ]]; then
  NEW="light"
else
  NEW="dark"
fi

if [[ "$NEW" == "dark" ]]; then
  gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
  gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
else
  gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
  gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
fi

# QT
QT6CT_CONF="$HOME/.config/qt6ct/qt6ct.conf"
QT_LIGHT_SCHEME="/usr/share/qt6ct/colors/simple.conf"
QT_DARK_SCHEME="/usr/share/qt6ct/colors/darker.conf"
if [[ -f "$QT6CT_CONF" ]]; then
  sed -i -E \
    -e "s|^color_scheme_path=.*|color_scheme_path=$([[ \"$NEW\" == \"dark\" ]] && echo \"$QT_DARK_SCHEME\" || echo \"$QT_LIGHT_SCHEME\")|" \
    "$QT6CT_CONF"
fi

# Ardour
ARDOUR_UI="$HOME/.config/ardour8/ui_config"
if [[ -f "$ARDOUR_UI" ]]; then
  sed -i -E \
    -e "s|(Option name=\"color-file\" value=\")[^\"]*(\")|\1$([[ \"$NEW\" == \"dark\" ]] && echo dark || echo captain_light)\2|" \
    "$ARDOUR_UI"
fi

kitten themes $([[ \"$NEW\" == \"dark\" ]] && echo My Theme || echo One Half Light)

hyprctl notify 5 3000 "rgb(ff1ea3)" "🌗_$NEW"

echo "$NEW" > ~/.config/theme/current_theme

