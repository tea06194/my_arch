#!/usr/bin/env bash

# Comprehensive Arch Linux Installation Guide
# This script provides step-by-step guidance for installing Arch Linux with Hyprland

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Logging functions
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
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

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

log_cmd() {
    echo -e "${CYAN}[COMMAND]${NC} $1"
}

# Print banner
print_banner() {
    echo
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                              ║${NC}"
    echo -e "${BLUE}║           ${GREEN}Arch Linux Installation Guide${BLUE}                    ║${NC}"
    echo -e "${BLUE}║                                                              ║${NC}"
    echo -e "${BLUE}║      Complete setup for Hyprland + NVIDIA configuration     ║${NC}"
    echo -e "${BLUE}║                                                              ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo
}

# Show prerequisites
show_prerequisites() {
    log_step "Prerequisites Check"
    echo
    echo "Before starting, ensure you have:"
    echo "  ✓ Arch Linux ISO booted"
    echo "  ✓ Internet connection active"
    echo "  ✓ Target disk identified"
    echo "  ✓ Backup of important data"
    echo

    log_warning "This installation will COMPLETELY WIPE the target disk!"
    echo

    read -p "Have you completed all prerequisites? [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "Please complete prerequisites first"
        exit 0
    fi
}

# Show installation steps overview
show_overview() {
    log_step "Installation Overview"
    echo
    echo "This guide will walk you through:"
    echo
    echo "  1️⃣  Basic Arch Linux installation"
    echo "  2️⃣  System configuration and setup"
    echo "  3️⃣  GPU drivers installation (NVIDIA/AMD/Intel)"
    echo "  4️⃣  Hyprland and Wayland setup"
    echo "  5️⃣  Configuration restoration from backup"
    echo "  6️⃣  Post-installation optimization"
    echo
    echo "Estimated time: 30-60 minutes"
    echo
}

# Step 1: Basic installation
step_basic_installation() {
    log_step "Step 1: Basic Arch Linux Installation"
    echo

    echo "Now we'll perform the basic Arch Linux installation."
    echo
    log_cmd "./install_arch.sh"
    echo
    echo "This script will:"
    echo "  • Partition your disk"
    echo "  • Install base system"
    echo "  • Configure bootloader"
    echo "  • Create user account"
    echo

    read -p "Run basic installation script? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [[ -f "$SCRIPT_DIR/install_arch.sh" ]]; then
            chmod +x "$SCRIPT_DIR/install_arch.sh"
            "$SCRIPT_DIR/install_arch.sh"
        else
            log_error "install_arch.sh not found!"
            exit 1
        fi
    else
        log_warning "Skipping basic installation. Make sure you have a working Arch Linux system."
    fi
}

# Step 2: System setup
step_system_setup() {
    log_step "Step 2: System Configuration and Setup"
    echo

    echo "After rebooting into your new system, run the system setup:"
    echo
    log_cmd "./setup_system.sh"
    echo
    echo "This script will:"
    echo "  • Install AUR helper (yay)"
    echo "  • Detect and setup GPU drivers"
    echo "  • Configure audio system (PipeWire)"
    echo "  • Install essential packages"
    echo "  • Setup Wayland environment"
    echo "  • Configure fonts and services"
    echo

    if [[ -f /etc/arch-release ]] && [[ ! -f /.dockerenv ]]; then
        read -p "Run system setup now? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if [[ -f "$SCRIPT_DIR/setup_system.sh" ]]; then
                chmod +x "$SCRIPT_DIR/setup_system.sh"
                "$SCRIPT_DIR/setup_system.sh"
            else
                log_error "setup_system.sh not found!"
            fi
        fi
    else
        log "Run this step after rebooting into your new Arch system"
    fi
}

# Step 3: GPU drivers
step_gpu_drivers() {
    log_step "Step 3: GPU Drivers Setup"
    echo

    echo "Choose your GPU type:"
    echo "  1) NVIDIA GPU"
    echo "  2) AMD GPU"
    echo "  3) Intel GPU"
    echo "  4) Skip GPU setup"
    echo

    read -p "Select option [1-4]: " -n 1 -r
    echo

    case $REPLY in
        1)
            echo "NVIDIA GPU selected"
            log_cmd "./setup_nvidia.sh"
            echo
            echo "This will configure NVIDIA drivers for Wayland/Hyprland"
            if [[ -f "$SCRIPT_DIR/setup_nvidia.sh" ]]; then
                read -p "Run NVIDIA setup? [y/N]: " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    chmod +x "$SCRIPT_DIR/setup_nvidia.sh"
                    "$SCRIPT_DIR/setup_nvidia.sh"
                fi
            fi
            ;;
        2)
            echo "AMD GPU: drivers are included in setup_system.sh"
            log "AMD drivers will be installed automatically"
            ;;
        3)
            echo "Intel GPU: drivers are included in setup_system.sh"
            log "Intel drivers will be installed automatically"
            ;;
        *)
            log "Skipping GPU setup"
            ;;
    esac
}

# Step 4: Hyprland setup
step_hyprland_setup() {
    log_step "Step 4: Hyprland and Wayland Setup"
    echo

    echo "Installing Hyprland and related packages..."
    echo

    local packages=(
        "hyprland hyprland-protocols"
        "waybar mako"
        "tofi kitty"
        "wl-clipboard grim slurp"
        "xdg-desktop-portal-hyprland"
        "polkit-gnome"
        "thunar thunar-archive-plugin"
    )

    log_cmd "yay -S ${packages[*]}"
    echo

    if command -v yay >/dev/null 2>&1; then
        read -p "Install Hyprland packages? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            yay -S --needed --noconfirm ${packages[*]}
            log_success "Hyprland packages installed"
        fi
    else
        log_warning "yay not found. Install it first with setup_system.sh"
    fi
}

# Step 5: Configuration restoration
step_restore_config() {
    log_step "Step 5: Configuration Restoration"
    echo

    echo "Restore your personal configuration from backup:"
    echo
    log_cmd "./restore_config.sh [username]"
    echo
    echo "This will restore:"
    echo "  • Installed packages (official + AUR)"
    echo "  • User configuration files"
    echo "  • Application settings"
    echo "  • Custom scripts and tools"
    echo "  • System services"
    echo

    if [[ -f "$SCRIPT_DIR/restore_config.sh" ]]; then
        read -p "Run configuration restoration? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            chmod +x "$SCRIPT_DIR/restore_config.sh"
            "$SCRIPT_DIR/restore_config.sh"
        fi
    else
        log_warning "restore_config.sh not found!"
    fi
}

# Step 6: Post-installation
step_post_installation() {
    log_step "Step 6: Post-Installation Tasks"
    echo

    echo "Complete the setup with these final tasks:"
    echo

    echo "1. Enable auto-login (optional):"
    log_cmd "sudo systemctl enable getty@tty1.service"
    echo

    echo "2. Configure Hyprland autostart:"
    echo "   Add to ~/.bash_profile:"
    echo "   if command -v uwsm >/dev/null && uwsm check may-start; then"
    echo "     exec uwsm start hyprland.desktop"
    echo "   fi"
    echo

    echo "3. Test Hyprland:"
    log_cmd "Hyprland"
    echo

    echo "4. Configure monitors in hyprland.conf:"
    echo "   monitor=HDMI-1,1920x1080@60,0x0,1"
    echo

    echo "5. Install additional software:"
    echo "   • Browser: firefox, google-chrome"
    echo "   • Media: mpv, vlc"
    echo "   • Development: vscode, neovim"
    echo "   • Communication: discord, telegram"
    echo
}

# Show troubleshooting guide
show_troubleshooting() {
    log_step "Troubleshooting Guide"
    echo

    echo -e "${YELLOW}Common Issues and Solutions:${NC}"
    echo

    echo "🔧 Boot Issues:"
    echo "   • Check GRUB configuration"
    echo "   • Verify NVIDIA kernel parameters"
    echo "   • Boot from USB and chroot to fix"
    echo

    echo "🔧 Display Issues:"
    echo "   • NVIDIA: Check WLR_NO_HARDWARE_CURSORS=1"
    echo "   • Try X11 session instead of Wayland"
    echo "   • Check monitor configuration in hyprland.conf"
    echo

    echo "🔧 Audio Issues:"
    echo "   • Restart PipeWire: systemctl --user restart pipewire"
    echo "   • Check audio devices: pavucontrol"
    echo "   • Verify PipeWire services are running"
    echo

    echo "🔧 Performance Issues:"
    echo "   • Check GPU drivers: nvidia-smi"
    echo "   • Monitor resources: htop"
    echo "   • Check compositor settings"
    echo

    echo "🔧 Package Issues:"
    echo "   • Update mirrors: sudo reflector --save /etc/pacman.d/mirrorlist"
    echo "   • Clear package cache: yay -Sc"
    echo "   • Rebuild AUR packages: yay -S --rebuild package-name"
    echo
}

# Show useful commands
show_useful_commands() {
    log_step "Useful Commands Reference"
    echo

    echo -e "${GREEN}System Management:${NC}"
    echo "  systemctl status service-name    # Check service status"
    echo "  journalctl -u service-name       # View service logs"
    echo "  systemctl --user restart pipewire # Restart audio"
    echo

    echo -e "${GREEN}Package Management:${NC}"
    echo "  yay -S package-name              # Install package"
    echo "  yay -R package-name              # Remove package"
    echo "  yay -Syu                         # Update system"
    echo "  yay -Sc                          # Clean cache"
    echo

    echo -e "${GREEN}GPU Monitoring:${NC}"
    echo "  nvidia-smi                       # NVIDIA status"
    echo "  watch -n1 nvidia-smi             # Live monitoring"
    echo "  nvidia-settings                  # NVIDIA control panel"
    echo

    echo -e "${GREEN}Hyprland:${NC}"
    echo "  hyprctl monitors                 # List monitors"
    echo "  hyprctl clients                  # List windows"
    echo "  hyprctl reload                   # Reload config"
    echo
}

# Show next steps
show_next_steps() {
    log_step "Next Steps"
    echo

    echo "After completing the installation:"
    echo
    echo "1. 📚 Read the documentation:"
    echo "   • Hyprland Wiki: https://wiki.hyprland.org/"
    echo "   • Arch Wiki: https://wiki.archlinux.org/"
    echo

    echo "2. 🎨 Customize your setup:"
    echo "   • Configure Waybar themes"
    echo "   • Set up wallpapers"
    echo "   • Customize Hyprland keybindings"
    echo

    echo "3. 🔧 Install additional software:"
    echo "   • Development tools"
    echo "   • Media applications"
    echo "   • Games and entertainment"
    echo

    echo "4. 🛡️ Security hardening:"
    echo "   • Configure firewall"
    echo "   • Set up automatic updates"
    echo "   • Configure backup system"
    echo

    echo "5. 📝 Create your own backup:"
    log_cmd "./create_backup.sh"
    echo
}

# Interactive menu
show_menu() {
    while true; do
        echo
        echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║                    Installation Menu                         ║${NC}"
        echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo
        echo "Choose an option:"
        echo
        echo "  1) Show prerequisites"
        echo "  2) Show installation overview"
        echo "  3) Run basic installation"
        echo "  4) Run system setup"
        echo "  5) Setup GPU drivers"
        echo "  6) Install Hyprland"
        echo "  7) Restore configuration"
        echo "  8) Post-installation tasks"
        echo "  9) Troubleshooting guide"
        echo " 10) Useful commands"
        echo " 11) Next steps"
        echo "  0) Exit"
        echo

        read -p "Select option [0-11]: " choice
        echo

        case $choice in
            1) show_prerequisites ;;
            2) show_overview ;;
            3) step_basic_installation ;;
            4) step_system_setup ;;
            5) step_gpu_drivers ;;
            6) step_hyprland_setup ;;
            7) step_restore_config ;;
            8) step_post_installation ;;
            9) show_troubleshooting ;;
            10) show_useful_commands ;;
            11) show_next_steps ;;
            0)
                log "Goodbye! Happy Arch Linux-ing! 🐧"
                exit 0
                ;;
            *)
                log_error "Invalid choice. Please select 0-11."
                ;;
        esac

        echo
        read -p "Press Enter to continue..." -r
    done
}

# Full automated installation
run_full_installation() {
    log_step "Running Full Automated Installation"
    echo

    log_warning "This will run the complete installation process automatically!"
    echo
    read -p "Are you sure you want to continue? [y/N]: " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "Automated installation cancelled"
        return
    fi

    show_prerequisites
    step_basic_installation

    echo
    log_success "Basic installation completed!"
    log "Please reboot and then run: $0 --continue"
    log "This will complete the remaining setup steps."
}

# Continue installation after reboot
continue_installation() {
    log_step "Continuing Installation After Reboot"
    echo

    step_system_setup
    step_gpu_drivers
    step_hyprland_setup
    step_restore_config
    step_post_installation

    log_success "Installation completed successfully!"
    show_next_steps
}

# Show help
show_help() {
    echo "Arch Linux Installation Guide"
    echo
    echo "Usage: $0 [OPTION]"
    echo
    echo "Options:"
    echo "  -h, --help        Show this help message"
    echo "  -m, --menu        Show interactive menu (default)"
    echo "  -f, --full        Run full automated installation"
    echo "  -c, --continue    Continue installation after reboot"
    echo "  -t, --troubleshoot Show troubleshooting guide"
    echo
    echo "Examples:"
    echo "  $0                # Show interactive menu"
    echo "  $0 --full         # Run automated installation"
    echo "  $0 --continue     # Continue after reboot"
    echo
}

# Main execution
main() {
    print_banner

    case "${1:-}" in
        -h|--help)
            show_help
            ;;
        -f|--full)
            run_full_installation
            ;;
        -c|--continue)
            continue_installation
            ;;
        -t|--troubleshoot)
            show_troubleshooting
            ;;
        -m|--menu|"")
            show_menu
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
}

# Parse arguments and run
main "$@"
