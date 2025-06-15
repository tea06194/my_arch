#!/usr/bin/env bash

# Restore configuration script for Arch Linux
# This script restores system configuration from backup

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${SCRIPT_DIR}"
TARGET_USER="${1:-$USER}"
TARGET_HOME="/home/${TARGET_USER}"

# Logging function
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

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root for user configuration restoration"
        log "Usage: $0 [username]"
        exit 1
    fi
}

# Verify backup exists
verify_backup() {
    local backup_user_dir="${BACKUP_DIR}/home/amtea"

    if [[ ! -d "$backup_user_dir" ]]; then
        log_error "Backup directory not found: $backup_user_dir"
        exit 1
    fi

    if [[ ! -f "$backup_user_dir/packages/packages.txt" ]]; then
        log_error "Package list not found in backup"
        exit 1
    fi

    log_success "Backup verification completed"
}

# Install packages from lists
install_packages() {
    local backup_packages="${BACKUP_DIR}/home/amtea/packages"

    log "Installing official packages..."
    if [[ -f "$backup_packages/packages.txt" ]]; then
        # Filter out packages that might not be available or cause conflicts
        local temp_packages=$(mktemp)

        # Remove problematic packages and base system packages
        grep -v -E "^(base|linux|linux-firmware|grub)$" "$backup_packages/packages.txt" > "$temp_packages"

        if command -v yay >/dev/null 2>&1; then
            yay -S --needed --noconfirm - < "$temp_packages" || log_warning "Some packages failed to install"
        else
            sudo pacman -S --needed --noconfirm - < "$temp_packages" || log_warning "Some packages failed to install"
        fi

        rm "$temp_packages"
        log_success "Official packages installation completed"
    else
        log_warning "packages.txt not found, skipping official packages"
    fi

    log "Installing AUR packages..."
    if [[ -f "$backup_packages/aur_packages.txt" ]]; then
        if command -v yay >/dev/null 2>&1; then
            while IFS= read -r package; do
                [[ -n "$package" ]] && yay -S --needed --noconfirm "$package" || log_warning "Failed to install AUR package: $package"
            done < "$backup_packages/aur_packages.txt"
            log_success "AUR packages installation completed"
        else
            log_warning "yay not found, skipping AUR packages. Install yay first."
        fi
    else
        log_warning "aur_packages.txt not found, skipping AUR packages"
    fi
}

# Restore user configuration files
restore_user_config() {
    local backup_user_dir="${BACKUP_DIR}/home/amtea"

    log "Restoring user configuration files..."

    # Create target directories
    mkdir -p "${TARGET_HOME}/.config"
    mkdir -p "${TARGET_HOME}/.local/share"

    # Restore shell configuration
    for file in .bashrc .bash_profile .makepkg.conf; do
        if [[ -f "$backup_user_dir/$file" ]]; then
            cp "$backup_user_dir/$file" "$TARGET_HOME/"
            log "Restored $file"
        fi
    done

    # Restore .config directory
    if [[ -d "$backup_user_dir/.config" ]]; then
        cp -r "$backup_user_dir/.config/"* "$TARGET_HOME/.config/" 2>/dev/null || true
        log "Restored .config directory"
    fi

    # Restore .local/share directory
    if [[ -d "$backup_user_dir/.local/share" ]]; then
        cp -r "$backup_user_dir/.local/share/"* "$TARGET_HOME/.local/share/" 2>/dev/null || true
        log "Restored .local/share directory"
    fi

    # Set correct ownership
    sudo chown -R "${TARGET_USER}:${TARGET_USER}" "$TARGET_HOME"

    log_success "User configuration restoration completed"
}

# Restore system services
restore_system_services() {
    local backup_system_dir="${BACKUP_DIR}/etc/systemd/system"

    if [[ ! -d "$backup_system_dir" ]]; then
        log_warning "System services backup not found, skipping"
        return
    fi

    log "Restoring system services..."

    # Copy systemd services
    if [[ -f "$backup_system_dir/numlock.service" ]]; then
        sudo cp "$backup_system_dir/numlock.service" /etc/systemd/system/
        log "Restored numlock.service"
    fi

    if [[ -d "$backup_system_dir/getty@tty1.service.d" ]]; then
        sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
        sudo cp "$backup_system_dir/getty@tty1.service.d/override.conf" /etc/systemd/system/getty@tty1.service.d/
        # Update autologin user
        sudo sed -i "s/--autologin amtea/--autologin ${TARGET_USER}/" /etc/systemd/system/getty@tty1.service.d/override.conf
        log "Restored getty autologin service"
    fi

    # Reload systemd
    sudo systemctl daemon-reload

    log_success "System services restoration completed"
}

# Install manual packages
install_manual_packages() {
    local backup_manual_dir="${BACKUP_DIR}/home/amtea/ManualPackages"

    if [[ ! -d "$backup_manual_dir" ]]; then
        log_warning "Manual packages backup not found, skipping"
        return
    fi

    log "Installing manual packages..."

    # Find and build PKGBUILD files
    find "$backup_manual_dir" -name "PKGBUILD" | while read -r pkgbuild; do
        local pkg_dir=$(dirname "$pkgbuild")
        local pkg_name=$(basename "$pkg_dir")

        log "Building package: $pkg_name"

        # Create temporary build directory
        local build_dir=$(mktemp -d)
        cp -r "$pkg_dir/"* "$build_dir/"

        cd "$build_dir"

        if makepkg -si --noconfirm; then
            log_success "Successfully built and installed: $pkg_name"
        else
            log_warning "Failed to build package: $pkg_name"
        fi

        cd - >/dev/null
        rm -rf "$build_dir"
    done

    log_success "Manual packages installation completed"
}

# Enable services
enable_services() {
    log "Enabling system services..."

    # Enable basic services
    local services=(
        "NetworkManager"
        "numlock"
    )

    for service in "${services[@]}"; do
        if systemctl list-unit-files | grep -q "^${service}.service"; then
            sudo systemctl enable "$service" && log "Enabled $service"
        else
            log_warning "Service $service not found"
        fi
    done

    log_success "Services enablement completed"
}

# Update font cache
update_fonts() {
    log "Updating font cache..."
    fc-cache -fv
    log_success "Font cache updated"
}

# Main execution
main() {
    log "Starting configuration restoration for user: $TARGET_USER"

    check_root
    verify_backup

    # Ask for confirmation
    echo
    echo "This will restore configuration for user: $TARGET_USER"
    echo "Target home directory: $TARGET_HOME"
    echo "Backup source: $BACKUP_DIR"
    echo
    read -p "Continue? [y/N]: " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "Restoration cancelled by user"
        exit 0
    fi

    # Execute restoration steps
    install_packages
    restore_user_config
    restore_system_services
    install_manual_packages
    enable_services
    update_fonts

    log_success "Configuration restoration completed successfully!"
    log "Please reboot the system to ensure all changes take effect."
    log "After reboot, you may need to:"
    log "  - Configure display settings in Hyprland"
    log "  - Set up NVIDIA settings if using NVIDIA GPU"
    log "  - Configure audio devices"
}

# Show help
show_help() {
    echo "Usage: $0 [username]"
    echo
    echo "Restore Arch Linux configuration from backup"
    echo
    echo "Arguments:"
    echo "  username    Target username (default: current user)"
    echo
    echo "Examples:"
    echo "  $0           # Restore for current user"
    echo "  $0 myuser    # Restore for user 'myuser'"
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
