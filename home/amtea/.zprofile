#
# ~/.zprofile
#

[[ -f ~/.zshrc ]] && . ~/.zshrc

export WLR_NO_HARDWARE_CURSORS=1
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export LIBVA_DRIVER_NAME=nvidia

# g fonts
SIZE=$(gsettings get org.gnome.desktop.interface font-name | grep -oP '\d+(?=.$)')
gsettings set org.gnome.desktop.interface document-font-name "Noto Sans ${SIZE:-11}"
gsettings set org.gnome.desktop.interface font-name "Noto Sans ${SIZE:-11}"
gsettings set org.gnome.desktop.interface monospace-font-name "Noto Sans Mono 12"

if command -v uwsm >/dev/null && uwsm check may-start; then
	exec uwsm start hyprland.desktop
fi
