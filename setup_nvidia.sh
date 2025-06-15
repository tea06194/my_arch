#!/usr/bin/env bash

# NVIDIA GPU setup script for Wayland/Hyprland
# This script configures NVIDIA drivers for optimal Wayland performance

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TARGET_USER="${1:-$USER}"
TARGET_HOME="/home/${TARGET_USER}"

# Logging functions
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if NVIDIA GPU is present
check_nvidia_gpu() {
    if ! lspci | grep -i nvidia >/dev/null 2>&1; then
        log_error "No NVIDIA GPU detected"
        exit 1
    fi
    log_success "NVIDIA GPU detected"
}

# Install NVIDIA drivers
install_nvidia_drivers() {
    log "Installing NVIDIA drivers..."

    # Install NVIDIA packages
    sudo pacman -S --needed --noconfirm \
        nvidia nvidia-utils nvidia-settings \
        lib32-nvidia-utils

    # Install DKMS version if user prefers
    read -p "Install NVIDIA DKMS drivers instead of regular? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo pacman -S --needed --noconfirm nvidia-dkms
        log "DKMS drivers installed"
    fi

    log_success "NVIDIA drivers installed"
}

# Configure kernel modules
configure_kernel_modules() {
    log "Configuring kernel modules..."

    # Backup original mkinitcpio.conf
    sudo cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.backup

    # Add NVIDIA modules to mkinitcpio
    if ! grep -q "nvidia" /etc/mkinitcpio.conf; then
        sudo sed -i 's/^MODULES=(/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm /' /etc/mkinitcpio.conf
        log "Added NVIDIA modules to mkinitcpio"
    else
        log "NVIDIA modules already present in mkinitcpio"
    fi

    # Regenerate initramfs
    sudo mkinitcpio -P

    log_success "Kernel modules configured"
}

# Configure GRUB
configure_grub() {
    log "Configuring GRUB for NVIDIA..."

    # Backup original GRUB config
    sudo cp /etc/default/grub /etc/default/grub.backup

    # Add NVIDIA kernel parameters
    local nvidia_params="nvidia-drm.modeset=1"

    if ! grep -q "$nvidia_params" /etc/default/grub; then
        sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"/&$nvidia_params /" /etc/default/grub
        log "Added NVIDIA parameters to GRUB"

        # Regenerate GRUB config
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        log "GRUB configuration regenerated"
    else
        log "NVIDIA parameters already present in GRUB"
    fi

    log_success "GRUB configured for NVIDIA"
}

# Configure environment variables
configure_environment() {
    log "Configuring environment variables..."

    # Create environment.d directory
    mkdir -p "${TARGET_HOME}/.config/environment.d"

    # Create NVIDIA environment file
    cat > "${TARGET_HOME}/.config/environment.d/nvidia.conf" << EOF
# NVIDIA Wayland configuration
WLR_NO_HARDWARE_CURSORS=1
GBM_BACKEND=nvidia-drm
__GLX_VENDOR_LIBRARY_NAME=nvidia
LIBVA_DRIVER_NAME=nvidia
WLR_DRM_NO_ATOMIC=1
XWAYLAND_NO_GLAMOR=1

# Additional NVIDIA settings for better compatibility
QT_QPA_PLATFORM=wayland
GDK_BACKEND=wayland
SDL_VIDEODRIVER=wayland
CLUTTER_BACKEND=wayland
EOF

    # Set proper ownership
    chown -R "${TARGET_USER}:${TARGET_USER}" "${TARGET_HOME}/.config/environment.d"

    log_success "Environment variables configured"
}

# Configure Xorg settings (fallback)
configure_xorg() {
    log "Configuring Xorg settings..."

    # Create Xorg configuration directory
    sudo mkdir -p /etc/X11/xorg.conf.d

    # Create NVIDIA Xorg configuration
    sudo tee /etc/X11/xorg.conf.d/20-nvidia.conf > /dev/null << EOF
Section "Device"
    Identifier "NVIDIA Card"
    Driver "nvidia"
    VendorName "NVIDIA Corporation"
    Option "NoLogo" "true"
    Option "UseEDID" "false"
    Option "ConnectedMonitor" "DFP"
    Option "CustomEDID" "DFP:/sys/class/drm/card0-DP-1/edid"
    Option "IgnoreEDID" "false"
    Option "UseDisplayDevice" "DFP"
EndSection
EOF

    log_success "Xorg configuration created"
}

# Configure modprobe
configure_modprobe() {
    log "Configuring modprobe..."

    # Create NVIDIA modprobe configuration
    sudo tee /etc/modprobe.d/nvidia.conf > /dev/null << EOF
# NVIDIA modprobe configuration
options nvidia-drm modeset=1
options nvidia NVreg_PreserveVideoMemoryAllocations=1
options nvidia NVreg_TemporaryFilePath=/var/tmp
EOF

    log_success "Modprobe configured"
}

# Setup NVIDIA persistence daemon
setup_nvidia_persistence() {
    log "Setting up NVIDIA persistence daemon..."

    # Create systemd service for NVIDIA persistence
    sudo tee /etc/systemd/system/nvidia-persistenced.service > /dev/null << EOF
[Unit]
Description=NVIDIA Persistence Daemon
Wants=syslog.target

[Service]
Type=forking
PIDFile=/var/run/nvidia-persistenced/nvidia-persistenced.pid
Restart=always
ExecStart=/usr/bin/nvidia-persistenced --verbose
ExecStopPost=/bin/rm -rf /var/run/nvidia-persistenced
User=nvidia-persistenced
Group=nvidia-persistenced

[Install]
WantedBy=multi-user.target
EOF

    # Create nvidia-persistenced user
    sudo useradd -r -s /bin/false nvidia-persistenced 2>/dev/null || true

    # Enable the service
    sudo systemctl enable nvidia-persistenced

    log_success "NVIDIA persistence daemon configured"
}

# Test NVIDIA installation
test_nvidia() {
    log "Testing NVIDIA installation..."

    # Test nvidia-smi
    if command -v nvidia-smi >/dev/null 2>&1; then
        log "nvidia-smi output:"
        nvidia-smi
        log_success "nvidia-smi working correctly"
    else
        log_error "nvidia-smi not found"
        return 1
    fi

    # Test OpenGL
    if command -v glxinfo >/dev/null 2>&1; then
        local renderer=$(glxinfo | grep -i "opengl renderer" || echo "Not found")
        log "OpenGL renderer: $renderer"
    else
        log_warning "glxinfo not available, install mesa-demos to test OpenGL"
    fi

    # Test Vulkan
    if command -v vulkaninfo >/dev/null 2>&1; then
        log "Vulkan devices:"
        vulkaninfo --summary | grep -A5 "GPU" || log_warning "No Vulkan devices found"
    else
        log_warning "vulkaninfo not available, install vulkan-tools to test Vulkan"
    fi

    log_success "NVIDIA testing completed"
}

# Create NVIDIA utilities script
create_nvidia_utils() {
    log "Creating NVIDIA utilities script..."

    # Create utilities directory
    mkdir -p "${TARGET_HOME}/.local/bin"

    # Create NVIDIA utilities script
    cat > "${TARGET_HOME}/.local/bin/nvidia-utils.sh" << 'EOF'
#!/bin/bash

# NVIDIA Utilities Script

show_help() {
    echo "NVIDIA Utilities"
    echo "Usage: nvidia-utils.sh [OPTION]"
    echo
    echo "Options:"
    echo "  status      Show NVIDIA GPU status"
    echo "  temp        Show GPU temperature"
    echo "  power       Show power consumption"
    echo "  processes   Show GPU processes"
    echo "  settings    Open NVIDIA settings"
    echo "  reset       Reset GPU (requires root)"
    echo "  help        Show this help"
}

case "$1" in
    status)
        nvidia-smi -q -d UTILIZATION,MEMORY,TEMPERATURE,POWER
        ;;
    temp)
        nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits
        ;;
    power)
        nvidia-smi --query-gpu=power.draw --format=csv,noheader
        ;;
    processes)
        nvidia-smi pmon -c 1
        ;;
    settings)
        nvidia-settings &
        ;;
    reset)
        if [[ $EUID -eq 0 ]]; then
            nvidia-smi --gpu-reset
        else
            sudo nvidia-smi --gpu-reset
        fi
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        nvidia-smi
        ;;
esac
EOF

    # Make script executable
    chmod +x "${TARGET_HOME}/.local/bin/nvidia-utils.sh"

    # Set proper ownership
    chown "${TARGET_USER}:${TARGET_USER}" "${TARGET_HOME}/.local/bin/nvidia-utils.sh"

    log_success "NVIDIA utilities script created"
}

# Main execution
main() {
    log "Starting NVIDIA setup for user: $TARGET_USER"

    # Check prerequisites
    check_nvidia_gpu

    # Show configuration
    echo
    echo "=== NVIDIA Setup Configuration ==="
    echo "Target user: $TARGET_USER"
    echo "Target home: $TARGET_HOME"
    echo

    read -p "Continue with NVIDIA setup? [y/N]: " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "NVIDIA setup cancelled by user"
        exit 0
    fi

    # Execute setup steps
    install_nvidia_drivers
    configure_kernel_modules
    configure_grub
    configure_environment
    configure_xorg
    configure_modprobe
    setup_nvidia_persistence
    create_nvidia_utils

    # Test installation
    test_nvidia

    log_success "NVIDIA setup completed successfully!"
    echo
    echo "=== NVIDIA Setup Complete ==="
    echo "Important notes:"
    echo "  - Reboot required for all changes to take effect"
    echo "  - Use 'nvidia-utils.sh' for GPU monitoring"
    echo "  - Environment variables are set for Wayland"
    echo "  - NVIDIA persistence daemon is enabled"
    echo
    echo "Troubleshooting:"
    echo "  - If Wayland doesn't work, try X11 session"
    echo "  - Check logs with: journalctl -u nvidia-persistenced"
    echo "  - Test with: nvidia-smi"
    echo

    read -p "Reboot now to apply changes? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo reboot
    fi
}

# Show help
show_help() {
    echo "Usage: $0 [username]"
    echo
    echo "NVIDIA GPU setup script for Wayland/Hyprland"
    echo
    echo "This script will:"
    echo "  - Install NVIDIA drivers"
    echo "  - Configure kernel modules"
    echo "  - Setup GRUB parameters"
    echo "  - Configure environment variables"
    echo "  - Setup Xorg fallback"
    echo "  - Configure modprobe"
    echo "  - Setup persistence daemon"
    echo "  - Create utility scripts"
    echo "  - Test installation"
    echo
    echo "Arguments:"
    echo "  username    Target username (default: current user)"
    echo
}

# Parse arguments
case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac
