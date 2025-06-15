#!/usr/bin/env bash

# Post-installation system setup script
# This script configures the system after base installation

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TARGET_USER="${1:-$USER}"
GPU_TYPE=""

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

# Check if running as regular user
check_user() {
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root"
        log "Usage: $0 [username]"
        exit 1
    fi
}

# Detect GPU type
detect_gpu() {
    log "Detecting GPU type..."

    if lspci | grep -i nvidia >/dev/null 2>&1; then
        GPU_TYPE="nvidia"
        log "NVIDIA GPU detected"
    elif lspci | grep -i amd >/dev/null 2>&1; then
        GPU_TYPE="amd"
        log "AMD GPU detected"
    elif lspci | grep -i intel >/dev/null 2>&1; then
        GPU_TYPE="intel"
        log "Intel GPU detected"
    else
        GPU_TYPE="unknown"
        log_warning "Unknown GPU type"
    fi
}

# Install AUR helper (yay)
install_yay() {
    if command -v yay >/dev/null 2>&1; then
        log "yay already installed"
        return
    fi

    log "Installing yay AUR helper..."

    # Create temporary directory
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"

    # Clone and build yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm

    # Cleanup
    cd /
    rm -rf "$temp_dir"

    log_success "yay installed successfully"
}

# Setup GPU drivers
setup_gpu_drivers() {
    log "Setting up GPU drivers for: $GPU_TYPE"

    case "$GPU_TYPE" in
        nvidia)
            setup_nvidia_drivers
            ;;
        amd)
            setup_amd_drivers
            ;;
        intel)
            setup_intel_drivers
            ;;
        *)
            log_warning "Skipping GPU driver setup for unknown GPU type"
            ;;
    esac
}

# Setup NVIDIA drivers
setup_nvidia_drivers() {
    log "Installing NVIDIA drivers..."

    # Install NVIDIA packages
    sudo pacman -S --needed --noconfirm \
        nvidia nvidia-utils nvidia-settings \
        lib32-nvidia-utils

    # Configure environment variables
    local env_file="/home/${TARGET_USER}/.config/environment.d/nvidia.conf"
    mkdir -p "$(dirname "$env_file")"

    cat > "$env_file" << EOF
# NVIDIA Wayland configuration
WLR_NO_HARDWARE_CURSORS=1
GBM_BACKEND=nvidia-drm
__GLX_VENDOR_LIBRARY_NAME=nvidia
LIBVA_DRIVER_NAME=nvidia
WLR_DRM_NO_ATOMIC=1
EOF

    # Add NVIDIA modules to mkinitcpio
    sudo sed -i 's/^MODULES=(/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm /' /etc/mkinitcpio.conf

    # Regenerate initramfs
    sudo mkinitcpio -P

    # Add NVIDIA kernel parameter
    if ! grep -q "nvidia-drm.modeset=1" /etc/default/grub; then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/&nvidia-drm.modeset=1 /' /etc/default/grub
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi

    log_success "NVIDIA drivers configured"
}

# Setup AMD drivers
setup_amd_drivers() {
    log "Installing AMD drivers..."

    # Install AMD packages
    sudo pacman -S --needed --noconfirm \
        mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon

    log_success "AMD drivers configured"
}

# Setup Intel drivers
setup_intel_drivers() {
    log "Installing Intel drivers..."

    # Install Intel packages
    sudo pacman -S --needed --noconfirm \
        mesa lib32-mesa vulkan-intel lib32-vulkan-intel

    log_success "Intel drivers configured"
}

# Setup audio system
setup_audio() {
    log "Setting up audio system..."

    # Install PipeWire packages
    sudo pacman -S --needed --noconfirm \
        pipewire pipewire-pulse pipewire-alsa pipewire-jack \
        wireplumber pavucontrol

    # Enable PipeWire services for user
    systemctl --user enable pipewire pipewire-pulse wireplumber

    log_success "Audio system configured"
}

# Install essential packages
install_essential_packages() {
    log "Installing essential packages..."

    # System utilities
    sudo pacman -S --needed --noconfirm \
        htop tree unzip zip \
        bash-completion \
        reflector \
        xdg-utils xdg-user-dirs \
        udisks2 \
        man-db man-pages

    # Development tools
    sudo pacman -S --needed --noconfirm \
        git neovim \
        base-devel \
        gdb

    # Network tools
    sudo pacman -S --needed --noconfirm \
        wget curl \
        openssh

    log_success "Essential packages installed"
}

# Setup Wayland environment
setup_wayland() {
    log "Setting up Wayland environment..."

    # Install Wayland packages
    sudo pacman -S --needed --noconfirm \
        wayland wayland-protocols \
        xorg-xwayland \
        xdg-desktop-portal-gtk

    log_success "Wayland environment configured"
}

# Setup fonts
setup_fonts() {
    log "Setting up fonts..."

    # Install essential fonts
    sudo pacman -S --needed --noconfirm \
        ttf-dejavu ttf-liberation \
        noto-fonts noto-fonts-emoji \
        ttf-nerd-fonts-symbols

    # Update font cache
    fc-cache -fv

    log_success "Fonts configured"
}

# Setup user directories
setup_user_directories() {
    log "Setting up user directories..."

    # Create XDG user directories
    sudo -u "$TARGET_USER" xdg-user-dirs-update

    # Create common directories
    sudo -u "$TARGET_USER" mkdir -p \
        "/home/${TARGET_USER}/Documents" \
        "/home/${TARGET_USER}/Downloads" \
        "/home/${TARGET_USER}/Pictures" \
        "/home/${TARGET_USER}/Videos" \
        "/home/${TARGET_USER}/Music" \
        "/home/${TARGET_USER}/.local/bin" \
        "/home/${TARGET_USER}/.config"

    log_success "User directories created"
}

# Enable essential services
enable_services() {
    log "Enabling essential services..."

    # System services
    local services=(
        "NetworkManager"
        "systemd-timesyncd"
        "fstrim.timer"
    )

    for service in "${services[@]}"; do
        if systemctl list-unit-files | grep -q "^${service}"; then
            sudo systemctl enable "$service" && log "Enabled $service"
        else
            log_warning "Service $service not found"
        fi
    done

    log_success "Essential services enabled"
}

# Configure reflector for automatic mirror updates
setup_reflector() {
    log "Configuring reflector..."

    # Create reflector configuration
    sudo tee /etc/xdg/reflector/reflector.conf > /dev/null << EOF
# Reflector configuration file for the systemd service
--save /etc/pacman.d/mirrorlist
--protocol https
--country Russia,Germany,France
--latest 20
--sort rate
--age 12
EOF

    # Enable reflector timer
    sudo systemctl enable reflector.timer

    log_success "Reflector configured"
}

# Optimize system performance
optimize_system() {
    log "Optimizing system performance..."

    # Configure swappiness
    echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-swappiness.conf

    # Configure I/O scheduler for SSDs
    if lsblk -d -o name,rota | grep -q "0$"; then
        echo 'ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"' | \
            sudo tee /etc/udev/rules.d/60-ioschedulers.rules
    fi

    # Enable periodic TRIM for SSDs
    sudo systemctl enable fstrim.timer

    log_success "System performance optimized"
}

# Setup security
setup_security() {
    log "Configuring security settings..."

    # Configure fail2ban if needed
    if command -v fail2ban-server >/dev/null 2>&1; then
        sudo systemctl enable fail2ban
    fi

    # Configure firewall (ufw)
    if command -v ufw >/dev/null 2>&1; then
        sudo ufw --force enable
        sudo systemctl enable ufw
    fi

    log_success "Security configured"
}

# Main execution
main() {
    log "Starting post-installation system setup for user: $TARGET_USER"

    check_user

    # Show configuration
    echo
    echo "=== System Setup Configuration ==="
    echo "Target user: $TARGET_USER"
    echo "Current user: $USER"
    echo

    read -p "Continue with system setup? [y/N]: " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "Setup cancelled by user"
        exit 0
    fi

    # Execute setup steps
    detect_gpu
    install_yay
    install_essential_packages
    setup_gpu_drivers
    setup_audio
    setup_wayland
    setup_fonts
    setup_user_directories
    enable_services
    setup_reflector
    optimize_system
    setup_security

    log_success "System setup completed successfully!"
    echo
    echo "=== Setup Complete ==="
    echo "Recommended next steps:"
    echo "  1. Reboot the system"
    echo "  2. Run restore_config.sh to restore your configuration"
    echo "  3. Install additional software as needed"
    echo
    log "You may need to reboot for some changes to take effect."
}

# Show help
show_help() {
    echo "Usage: $0 [username]"
    echo
    echo "Post-installation system setup script"
    echo
    echo "This script will:"
    echo "  - Install AUR helper (yay)"
    echo "  - Setup GPU drivers"
    echo "  - Configure audio system"
    echo "  - Install essential packages"
    echo "  - Setup Wayland environment"
    echo "  - Configure fonts"
    echo "  - Enable essential services"
    echo "  - Optimize system performance"
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
