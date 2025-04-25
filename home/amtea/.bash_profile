#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
export WLR_NO_HARDWARE_CURSORS=1
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export LIBVA_DRIVER_NAME=nvidia

if command -v uwsm >/dev/null && uwsm check may-start; then
  exec uwsm start hyprland.desktop
fi

