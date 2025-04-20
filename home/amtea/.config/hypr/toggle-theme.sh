#!/usr/bin/env bash

# toggle-theme.sh — переключение темы light ↔ dark в нескольких конфигах
# Меняет:
#  • ~/.config/gtk-3.0/settings.ini (gtk-application-prefer-dark-theme)
#  • ~/.config/qt6ct/qt6ct.conf (color_scheme_path)
#  • ~/.config/qt5ct/qt5ct.conf (color_scheme_path)
#  • ~/.config/ardour8/ui_config (Option name="color-file")
#  • стиль Waybar и уведомление

# Пути к файлам
GTK3_CONF="$HOME/.config/gtk-3.0/settings.ini"
QT6CT_CONF="$HOME/.config/qt6ct/qt6ct.conf"
# QT5CT_CONF="$HOME/.config/qt5ct/qt5ct.conf"
ARDOUR_UI="$HOME/.config/ardour8/ui_config"
WAYBAR_DIR="$HOME/.config/waybar"

# Пути к схемам Qt
QT_LIGHT_SCHEME="/usr/share/qt6ct/colors/simple.conf"
QT_DARK_SCHEME="/usr/share/qt6ct/colors/darker.conf"

# Определяем текущую тему по gtk-application-prefer-dark-theme
CURRENT_GTK=$(grep -E '^gtk-application-prefer-dark-theme' "$GTK3_CONF" | cut -d= -f2)
if [[ "$CURRENT_GTK" == "1" ]]; then
  NEW="light"
else
  NEW="dark"
fi

# 1) Обновляем gtk-3.0/settings.ini
#    меняем только prefer-dark, остальные опции оставляем
sed -i -E \
  -e "s|^gtk-application-prefer-dark-theme=.*|gtk-application-prefer-dark-theme=$([[ \"$NEW\" == \"dark\" ]] && echo 1 || echo 0)|" \
  "$GTK3_CONF"

# 2) Обновляем qt6ct.conf и qt5ct.conf
if [[ -f "$QT6CT_CONF" ]]; then
  sed -i -E \
    -e "s|^color_scheme_path=.*|color_scheme_path=$([[ \"$NEW\" == \"dark\" ]] && echo \"$QT_DARK_SCHEME\" || echo \"$QT_LIGHT_SCHEME\")|" \
    "$QT6CT_CONF"
fi
# if [[ -f "$QT5CT_CONF" ]]; then
#   sed -i -E \
#     -e "s|^color_scheme_path=.*|color_scheme_path=$([[ \"$NEW\" == \"dark\" ]] && echo \"$QT_DARK_SCHEME\" || echo \"$QT_LIGHT_SCHEME\")|" \
#     "$QT5CT_CONF"
# fi

# 3) Обновляем Ardour ui_config: цветовая схема
if [[ -f "$ARDOUR_UI" ]]; then
  sed -i -E \
    -e "s|(Option name=\"color-file\" value=\")[^\"]*(\")|\1$([[ \"$NEW\" == \"dark\" ]] && echo dark || echo captain_light)\2|" \
    "$ARDOUR_UI"
fi

# 4) Переключаем стиль Waybar
cp "$WAYBAR_DIR/style-$NEW.css" "$WAYBAR_DIR/style.css"
pkill waybar && waybar &

kitten themes $([[ \"$NEW\" == \"dark\" ]] && echo My Theme || echo One Half Light)
# 5) Уведомление
# if command -v hyprctl &>/dev/null && hyprctl help | grep -q notify; then
hyprctl notify 5 3000 "rgb(ff1ea3)" "🌗_$NEW"
# else
  # fallback через dbus-send
  # dbus-send --session \
  #   --dest=org.freedesktop.Notifications \
  #   --type=method_call \
  #   /org/freedesktop/Notifications \
  #   org.freedesktop.Notifications.Notify \
  #   string:"theme-toggle" uint32:0 string:"" \
  #   string:"🌗 Тема: $NEW" string:"Переключено" \
  #   array:string:"" dict:string:string:"" int32:3000
# fi
