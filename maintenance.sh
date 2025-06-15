#!/usr/bin/env bash

# System maintenance and backup script for Arch Linux
# This script performs regular maintenance tasks and creates system backups

set -e  # Exit on any error

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
BACKUP_DIR="${SCRIPT_DIR}"
LOG_FILE="/var/log/system-maintenance.log"
TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME="/home/${TARGET_USER}"

# Logging functions
log() {
    local message="[$(date '+%Y-%m-%d %H:%M:%S')] $1"
    echo -e "${BLUE}[INFO]${NC} $1"
    echo "$message" >> "$LOG_FILE" 2>/dev/null || true
}

log_success() {
    local message="[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $1"
    echo -e "${GREEN}[SUCCESS]${NC} $1"
    echo "$message" >> "$LOG_FILE" 2>/dev/null || true
}

log_warning() {
    local message="[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: $1"
    echo -e "${YELLOW}[WARNING]${NC} $1"
    echo "$message" >> "$LOG_FILE" 2>/dev/null || true
}

log_error() {
    local message="[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1"
    echo -e "${RED}[ERROR]${NC} $1"
    echo "$message" >> "$LOG_FILE" 2>/dev/null || true
}

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

# Check if running with appropriate privileges
check_privileges() {
    if [[ $EUID -eq 0 ]]; then
        log_warning "Running as root. Some user-specific tasks will be skipped."
    fi
}

# Update system packages
update_packages() {
    log_step "Updating system packages"

    log "Updating package databases..."
    if command -v yay >/dev/null 2>&1; then
        yay -Sy --noconfirm
    else
        sudo pacman -Sy --noconfirm
    fi

    log "Updating all packages..."
    if command -v yay >/dev/null 2>&1; then
        yay -Syu --noconfirm --norebuild
    else
        sudo pacman -Syu --noconfirm
    fi

    log_success "Package update completed"
}

# Clean package cache
clean_package_cache() {
    log_step "Cleaning package cache"

    log "Cleaning pacman cache..."
    sudo pacman -Sc --noconfirm

    if command -v yay >/dev/null 2>&1; then
        log "Cleaning yay cache..."
        yay -Sc --noconfirm
    fi

    # Remove orphaned packages
    log "Removing orphaned packages..."
    local orphans=$(pacman -Qtdq 2>/dev/null || true)
    if [[ -n "$orphans" ]]; then
        echo "$orphans" | sudo pacman -Rns --noconfirm -
        log_success "Removed orphaned packages"
    else
        log "No orphaned packages found"
    fi

    log_success "Package cache cleanup completed"
}

# Update mirror list
update_mirrors() {
    log_step "Updating mirror list"

    if command -v reflector >/dev/null 2>&1; then
        log "Updating mirror list with reflector..."
        sudo reflector \
            --country Russia,Germany,France \
            --age 12 \
            --protocol https \
            --sort rate \
            --save /etc/pacman.d/mirrorlist

        log_success "Mirror list updated"
    else
        log_warning "Reflector not installed, skipping mirror update"
    fi
}

# Clean system logs
clean_logs() {
    log_step "Cleaning system logs"

    # Clean systemd journal logs older than 2 weeks
    log "Cleaning systemd journal logs..."
    sudo journalctl --vacuum-time=2weeks

    # Clean old log files
    log "Cleaning old log files..."
    sudo find /var/log -name "*.log.*" -type f -mtime +30 -delete 2>/dev/null || true
    sudo find /var/log -name "*.gz" -type f -mtime +30 -delete 2>/dev/null || true

    log_success "Log cleanup completed"
}

# Clean temporary files
clean_temp_files() {
    log_step "Cleaning temporary files"

    # Clean /tmp
    log "Cleaning /tmp directory..."
    sudo find /tmp -type f -atime +7 -delete 2>/dev/null || true

    # Clean user cache
    if [[ -d "$TARGET_HOME/.cache" ]]; then
        log "Cleaning user cache directory..."
        find "$TARGET_HOME/.cache" -type f -atime +30 -delete 2>/dev/null || true
    fi

    # Clean thumbnail cache
    if [[ -d "$TARGET_HOME/.thumbnails" ]]; then
        log "Cleaning thumbnail cache..."
        find "$TARGET_HOME/.thumbnails" -type f -atime +30 -delete 2>/dev/null || true
    fi

    # Clean browser caches
    for browser_cache in "$TARGET_HOME/.cache/google-chrome" "$TARGET_HOME/.cache/firefox" "$TARGET_HOME/.cache/chromium"; do
        if [[ -d "$browser_cache" ]]; then
            log "Cleaning $(basename "$browser_cache") cache..."
            find "$browser_cache" -type f -name "*.tmp" -delete 2>/dev/null || true
        fi
    done

    log_success "Temporary files cleanup completed"
}

# Check disk usage
check_disk_usage() {
    log_step "Checking disk usage"

    echo
    echo -e "${CYAN}Disk Usage Summary:${NC}"
    df -h / /boot /home 2>/dev/null || df -h /

    echo
    echo -e "${CYAN}Largest directories in /home:${NC}"
    du -sh "$TARGET_HOME"/* 2>/dev/null | sort -hr | head -10 || true

    echo
    echo -e "${CYAN}Package cache size:${NC}"
    du -sh /var/cache/pacman/pkg/ 2>/dev/null || true

    # Check for low disk space
    local root_usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
    if [[ $root_usage -gt 90 ]]; then
        log_warning "Root filesystem is ${root_usage}% full!"
    elif [[ $root_usage -gt 80 ]]; then
        log_warning "Root filesystem is ${root_usage}% full"
    fi

    log_success "Disk usage check completed"
}

# Check system health
check_system_health() {
    log_step "Checking system health"

    # Check failed systemd services
    log "Checking for failed systemd services..."
    local failed_services=$(systemctl --failed --no-legend | wc -l)
    if [[ $failed_services -gt 0 ]]; then
        log_warning "$failed_services failed services found:"
        systemctl --failed --no-legend
    else
        log "No failed services found"
    fi

    # Check system load
    log "Checking system load..."
    local load_avg=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
    local cpu_cores=$(nproc)
    log "Load average: $load_avg (${cpu_cores} cores available)"

    # Check memory usage
    log "Checking memory usage..."
    free -h

    # Check for kernel errors
    log "Checking for recent kernel errors..."
    local kernel_errors=$(dmesg -l err -T --since "1 hour ago" 2>/dev/null | wc -l)
    if [[ $kernel_errors -gt 0 ]]; then
        log_warning "$kernel_errors kernel errors found in the last hour"
    else
        log "No recent kernel errors found"
    fi

    log_success "System health check completed"
}

# Update font cache
update_font_cache() {
    log_step "Updating font cache"

    if [[ $EUID -ne 0 ]]; then
        fc-cache -fv
        log_success "Font cache updated"
    else
        log_warning "Skipping font cache update (running as root)"
    fi
}

# Update desktop database
update_desktop_database() {
    log_step "Updating desktop database"

    if [[ $EUID -ne 0 ]]; then
        update-desktop-database "$TARGET_HOME/.local/share/applications" 2>/dev/null || true
        log_success "Desktop database updated"
    else
        log_warning "Skipping desktop database update (running as root)"
    fi
}

# Check and fix broken symlinks
fix_broken_symlinks() {
    log_step "Checking for broken symlinks"

    local broken_links=0

    # Check common directories for broken symlinks
    for dir in "$TARGET_HOME" "/usr/bin" "/usr/local/bin"; do
        if [[ -d "$dir" ]]; then
            while IFS= read -r -d '' link; do
                if [[ ! -e "$link" ]]; then
                    log_warning "Broken symlink found: $link"
                    ((broken_links++))
                fi
            done < <(find "$dir" -type l -print0 2>/dev/null)
        fi
    done

    if [[ $broken_links -eq 0 ]]; then
        log_success "No broken symlinks found"
    else
        log_warning "Found $broken_links broken symlinks"
    fi
}

# Create configuration backup
create_backup() {
    log_step "Creating configuration backup"

    if [[ -f "$SCRIPT_DIR/create_backup.sh" ]]; then
        log "Running backup script..."
        chmod +x "$SCRIPT_DIR/create_backup.sh"
        "$SCRIPT_DIR/create_backup.sh"
        log_success "Configuration backup completed"
    else
        log_warning "Backup script not found at $SCRIPT_DIR/create_backup.sh"
    fi
}

# Generate system information report
generate_system_report() {
    local report_file="/tmp/system-report-$(date +%Y%m%d-%H%M%S).txt"

    log_step "Generating system information report"

    cat > "$report_file" << EOF
System Information Report
Generated: $(date)
==========================

Hostname: $(hostname)
Uptime: $(uptime)
Kernel: $(uname -a)

CPU Information:
$(lscpu | head -10)

Memory Information:
$(free -h)

Disk Usage:
$(df -h)

Network Interfaces:
$(ip addr show | grep -E '^[0-9]+:|inet ')

GPU Information:
$(lspci | grep -i vga)
$(nvidia-smi 2>/dev/null | head -10 || echo "NVIDIA GPU not found or nvidia-smi not available")

Active Services:
$(systemctl list-units --type=service --state=active --no-legend | head -20)

Recent Errors:
$(journalctl -p err -n 10 --no-pager 2>/dev/null || echo "No recent errors")

Package Count:
Official packages: $(pacman -Qq | wc -l)
AUR packages: $(pacman -Qqm | wc -l)

Last Updated:
$(grep -E '^\[.*\]' /var/log/pacman.log | tail -5)
EOF

    log "System report saved to: $report_file"
    log_success "System information report generated"
}

# Run security check
run_security_check() {
    log_step "Running security checks"

    # Check for SUID files
    log "Checking for SUID files..."
    local suid_count=$(find /usr -perm -4000 -type f 2>/dev/null | wc -l)
    log "Found $suid_count SUID files"

    # Check SSH configuration
    if [[ -f /etc/ssh/sshd_config ]]; then
        log "Checking SSH configuration..."
        if grep -q "PermitRootLogin yes" /etc/ssh/sshd_config; then
            log_warning "SSH root login is enabled"
        fi
        if grep -q "PasswordAuthentication yes" /etc/ssh/sshd_config; then
            log_warning "SSH password authentication is enabled"
        fi
    fi

    # Check for world-writable files
    log "Checking for world-writable files in system directories..."
    local writable_count=$(find /etc /usr -perm -002 -type f 2>/dev/null | wc -l)
    if [[ $writable_count -gt 0 ]]; then
        log_warning "Found $writable_count world-writable files in system directories"
    fi

    log_success "Security check completed"
}

# Show maintenance summary
show_summary() {
    log_step "Maintenance Summary"

    echo
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                     Maintenance Complete                     ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo

    echo "Tasks completed:"
    echo "  ✓ System packages updated"
    echo "  ✓ Package cache cleaned"
    echo "  ✓ Mirror list updated"
    echo "  ✓ System logs cleaned"
    echo "  ✓ Temporary files removed"
    echo "  ✓ Disk usage checked"
    echo "  ✓ System health verified"
    echo "  ✓ Font cache updated"
    echo "  ✓ Desktop database updated"
    echo "  ✓ Broken symlinks checked"
    echo "  ✓ Security check performed"
    echo "  ✓ Configuration backup created"
    echo "  ✓ System report generated"
    echo

    echo "Log file: $LOG_FILE"
    echo "Next recommended maintenance: $(date -d '+1 week' '+%Y-%m-%d')"
    echo
}

# Run full maintenance
run_full_maintenance() {
    log "Starting full system maintenance..."

    check_privileges
    update_packages
    clean_package_cache
    update_mirrors
    clean_logs
    clean_temp_files
    check_disk_usage
    check_system_health
    update_font_cache
    update_desktop_database
    fix_broken_symlinks
    run_security_check
    create_backup
    generate_system_report
    show_summary

    log_success "Full maintenance completed successfully!"
}

# Run quick maintenance
run_quick_maintenance() {
    log "Starting quick system maintenance..."

    check_privileges
    clean_package_cache
    clean_temp_files
    check_disk_usage
    update_font_cache

    log_success "Quick maintenance completed!"
}

# Run backup only
run_backup_only() {
    log "Creating system backup..."

    create_backup

    log_success "Backup completed!"
}

# Show help
show_help() {
    echo "System Maintenance and Backup Script"
    echo
    echo "Usage: $0 [OPTION]"
    echo
    echo "Options:"
    echo "  -h, --help         Show this help message"
    echo "  -f, --full         Run full maintenance (default)"
    echo "  -q, --quick        Run quick maintenance"
    echo "  -b, --backup       Create backup only"
    echo "  -c, --check        Check system health only"
    echo "  -r, --report       Generate system report only"
    echo "  -s, --security     Run security check only"
    echo
    echo "Examples:"
    echo "  $0                 # Run full maintenance"
    echo "  $0 --quick         # Run quick maintenance"
    echo "  $0 --backup        # Create backup only"
    echo
    echo "Note: Some operations require sudo privileges"
}

# Main execution
main() {
    # Create log file if it doesn't exist
    sudo touch "$LOG_FILE" 2>/dev/null || LOG_FILE="/tmp/maintenance.log"

    case "${1:-}" in
        -h|--help)
            show_help
            ;;
        -q|--quick)
            run_quick_maintenance
            ;;
        -b|--backup)
            run_backup_only
            ;;
        -c|--check)
            check_system_health
            ;;
        -r|--report)
            generate_system_report
            ;;
        -s|--security)
            run_security_check
            ;;
        -f|--full|"")
            run_full_maintenance
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
