#!/usr/bin/env zsh
setopt errexit nounset pipefail

toggle_theme() {
	local raw current next
	raw=$(gsettings get org.gnome.desktop.interface color-scheme)
	current=${raw//\'/}

	case $current in
		prefer-dark) next=prefer-light ;;
		prefer-light) next=prefer-dark ;;
		*)
			next=prefer-dark
			f
			;;
	esac

	gsettings set org.gnome.desktop.interface color-scheme "$next"
	gsettings set org.gnome.desktop.interface gtk-theme "${next/#prefer-/}"

	qt_conf="$HOME/.config/qt6ct/qt6ct.conf"
	[[ -f $qt_conf ]] && sed -i \
		-E "s|^color_scheme_path=.*|color_scheme_path=${next/#prefer-/}.conf|" \
		"$qt_conf"

	ardour_ui="$HOME/.config/ardour8/ui_config"
	[[ -f $ardour_ui ]] && sed -i \
		-E "s|(Option name=\"color-file\" value=\")[^\"]*(\")|\1${next/#prefer-/}\2|" \
		"$ardour_ui"

	hyprctl notify 5 3000 "rgb(ff1ea3)" "🌗  ${next/#prefer-/}"

	printf '%s' "${next/#prefer-/}" >~/.config/theme/current_theme
}

toggle_theme
