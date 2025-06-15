#!/usr/bin/env bash

# Arch Linux installation script
# This script performs a basic Arch Linux installation

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration variables
HOSTNAME=""
USERNAME=""
USER_PASSWORD=""
ROOT_PASSWORD=""
DISK=""
TIMEZONE="Europe/Moscow"
KEYMAP="us"
LOCALE="en_US.UTF-8"

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

# Check if running from Arch ISO
check_arch_iso() {
    if [[ ! -f /etc/arch-release ]]; then
        log_error "This script must be run from Arch Linux ISO"
        exit 1
    fi
    log_success "Running from Arch Linux ISO"
}

# Update system clock
update_clock() {
    log "Updating system clock..."
    timedatectl set-ntp true
    log_success "System clock updated"
}

# Get user input
get_user_input() {
    echo
    echo "=== Arch Linux Installation Configuration ==="
    echo

    # Hostname
    while [[ -z "$HOSTNAME" ]]; do
        read -p "Enter hostname: " HOSTNAME
    done

    # Username
    while [[ -z "$USERNAME" ]]; do
        read -p "Enter username: " USERNAME
    done

    # User password
    while [[ -z "$USER_PASSWORD" ]]; do
        read -s -p "Enter user password: " USER_PASSWORD
        echo
        read -s -p "Confirm user password: " USER_PASSWORD_CONFIRM
        echo
        if [[ "$USER_PASSWORD" != "$USER_PASSWORD_CONFIRM" ]]; then
            log_error "Passwords do not match"
            USER_PASSWORD=""
        fi
    done

    # Root password
    while [[ -z "$ROOT_PASSWORD" ]]; do
        read -s -p "Enter root password: " ROOT_PASSWORD
        echo
        read -s -p "Confirm root password: " ROOT_PASSWORD_CONFIRM
        echo
        if [[ "$ROOT_PASSWORD" != "$ROOT_PASSWORD_CONFIRM" ]]; then
            log_error "Passwords do not match"
            ROOT_PASSWORD=""
        fi
    done

    # Disk selection
    echo
    echo "Available disks:"
    lsblk -dpno NAME,SIZE,MODEL | grep -E '^/dev/(sd|nvme|vd)'
    echo
    while [[ -z "$DISK" ]]; do
        read -p "Enter disk to install to (e.g., /dev/sda): " DISK
        if [[ ! -b "$DISK" ]]; then
            log_error "Invalid disk: $DISK"
            DISK=""
        fi
    done

    # Timezone
    echo
    read -p "Enter timezone (default: $TIMEZONE): " TIMEZONE_INPUT
    [[ -n "$TIMEZONE_INPUT" ]] && TIMEZONE="$TIMEZONE_INPUT"

    # Show configuration summary
    echo
    echo "=== Installation Summary ==="
    echo "Hostname: $HOSTNAME"
    echo "Username: $USERNAME"
    echo "Disk: $DISK"
    echo "Timezone: $TIMEZONE"
    echo "Keymap: $KEYMAP"
    echo "Locale: $LOCALE"
    echo

    read -p "Continue with installation? [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "Installation cancelled by user"
        exit 0
    fi
}

# Partition disk
partition_disk() {
    log "Partitioning disk: $DISK"

    # Check if disk is NVME
    if [[ "$DISK" == *"nvme"* ]]; then
        BOOT_PARTITION="${DISK}p1"
        ROOT_PARTITION="${DISK}p2"
    else
        BOOT_PARTITION="${DISK}1"
        ROOT_PARTITION="${DISK}2"
    fi

    # Wipe disk
    wipefs -af "$DISK"

    # Create partitions using fdisk
    (
    echo g      # Create GPT partition table
    echo n      # New partition
    echo 1      # Partition number
    echo        # First sector (default)
    echo +512M  # Boot partition size
    echo t      # Change partition type
    echo 1      # EFI System
    echo n      # New partition
    echo 2      # Partition number
    echo        # First sector (default)
    echo        # Last sector (default - use remaining space)
    echo w      # Write changes
    ) | fdisk "$DISK"

    # Wait for partition creation
    sleep 2

    log_success "Disk partitioned successfully"
}

# Format partitions
format_partitions() {
    log "Formatting partitions..."

    # Format boot partition (FAT32)
    mkfs.fat -F32 "$BOOT_PARTITION"

    # Format root partition (ext4)
    mkfs.ext4 "$ROOT_PARTITION"

    log_success "Partitions formatted successfully"
}

# Mount partitions
mount_partitions() {
    log "Mounting partitions..."

    # Mount root partition
    mount "$ROOT_PARTITION" /mnt

    # Create and mount boot partition
    mkdir -p /mnt/boot
    mount "$BOOT_PARTITION" /mnt/boot

    log_success "Partitions mounted successfully"
}

# Install base system
install_base_system() {
    log "Installing base system..."

    # Update mirror list
    reflector --country Russia,Germany --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

    # Install base packages
    pacstrap /mnt base base-devel linux linux-firmware linux-headers \
        grub efibootmgr networkmanager sudo neovim git wget curl

    log_success "Base system installed successfully"
}

# Generate fstab
generate_fstab() {
    log "Generating fstab..."
    genfstab -U /mnt >> /mnt/etc/fstab
    log_success "fstab generated successfully"
}

# Configure system
configure_system() {
    log "Configuring system..."

    # Create configuration script for chroot
    cat > /mnt/configure_chroot.sh << EOF
#!/bin/bash

# Set timezone
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

# Set locale
echo "$LOCALE UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=$LOCALE" > /etc/locale.conf

# Set keymap
echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf

# Set hostname
echo "$HOSTNAME" > /etc/hostname

# Configure hosts file
cat > /etc/hosts << HOSTS_EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain $HOSTNAME
HOSTS_EOF

# Set root password
echo "root:$ROOT_PASSWORD" | chpasswd

# Create user
useradd -m -G wheel,audio,video,optical,storage -s /bin/bash $USERNAME
echo "$USERNAME:$USER_PASSWORD" | chpasswd

# Configure sudo
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Enable NetworkManager
systemctl enable NetworkManager

# Install and configure GRUB
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

EOF

    # Make script executable and run it
    chmod +x /mnt/configure_chroot.sh
    arch-chroot /mnt /configure_chroot.sh

    # Remove configuration script
    rm /mnt/configure_chroot.sh

    log_success "System configured successfully"
}

# Install additional packages
install_additional_packages() {
    log "Installing additional packages..."

    # Create package installation script
    cat > /mnt/install_packages.sh << EOF
#!/bin/bash

# Install essential packages
pacman -S --noconfirm \\
    htop tree unzip zip \\
    bash-completion \\
    reflector \\
    intel-ucode \\
    xdg-utils xdg-user-dirs

# Create user directories
sudo -u $USERNAME xdg-user-dirs-update

EOF

    chmod +x /mnt/install_packages.sh
    arch-chroot /mnt /install_packages.sh
    rm /mnt/install_packages.sh

    log_success "Additional packages installed successfully"
}

# Cleanup and finish
finish_installation() {
    log "Finishing installation..."

    # Unmount partitions
    umount -R /mnt

    log_success "Installation completed successfully!"
    echo
    echo "=== Installation Complete ==="
    echo "System: $HOSTNAME"
    echo "User: $USERNAME"
    echo "Disk: $DISK"
    echo
    echo "You can now reboot into your new Arch Linux system."
    echo "After reboot, you can run the restore_config.sh script to restore your configuration."
    echo
    read -p "Reboot now? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        reboot
    fi
}

# Show help
show_help() {
    echo "Arch Linux Installation Script"
    echo
    echo "This script will:"
    echo "  1. Partition the selected disk"
    echo "  2. Install base Arch Linux system"
    echo "  3. Configure basic system settings"
    echo "  4. Install GRUB bootloader"
    echo "  5. Create user account"
    echo
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -h, --help    Show this help message"
    echo
    echo "WARNING: This will completely wipe the selected disk!"
    echo
}

# Main execution
main() {
    log "Starting Arch Linux installation..."

    check_arch_iso
    update_clock
    get_user_input
    partition_disk
    format_partitions
    mount_partitions
    install_base_system
    generate_fstab
    configure_system
    install_additional_packages
    finish_installation
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
