#!/usr/bin/env bash

# NixOS Configuration Setup Script
# This script helps you set up your NixOS configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on NixOS
if [ ! -f /etc/NIXOS ]; then
    print_error "This script must be run on NixOS!"
    exit 1
fi

print_info "Setting up NixOS configuration..."

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
print_info "Configuration directory: $SCRIPT_DIR"

# Prompt for username
read -p "Enter your username (default: jager): " USERNAME
USERNAME=${USERNAME:-jager}

# Prompt for hostname
read -p "Enter your hostname (default: nixos): " HOSTNAME
HOSTNAME=${HOSTNAME:-nixos}

# Prompt for full name
read -p "Enter your full name: " FULLNAME

# Prompt for email
read -p "Enter your email address: " EMAIL

# Prompt for timezone
print_info "Common timezones: America/New_York, Europe/London, Asia/Tokyo, America/Los_Angeles"
read -p "Enter your timezone (default: America/New_York): " TIMEZONE
TIMEZONE=${TIMEZONE:-America/New_York}

# Prompt for desktop environment
echo "Available desktop environments:"
echo "1) GNOME (default)"
echo "2) KDE Plasma"
echo "3) XFCE"
echo "4) None (headless)"
read -p "Choose desktop environment (1-4, default: 1): " DESKTOP_CHOICE
case $DESKTOP_CHOICE in
    2) DESKTOP="kde" ;;
    3) DESKTOP="xfce" ;;
    4) DESKTOP="none" ;;
    *) DESKTOP="gnome" ;;
esac

print_info "Configuration summary:"
print_info "  Username: $USERNAME"
print_info "  Hostname: $HOSTNAME"
print_info "  Full Name: $FULLNAME"
print_info "  Email: $EMAIL"
print_info "  Timezone: $TIMEZONE"
print_info "  Desktop: $DESKTOP"

read -p "Continue with these settings? (y/N): " CONFIRM
if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
    print_info "Setup cancelled."
    exit 0
fi

# Backup existing configuration
if [ -d /etc/nixos ]; then
    print_info "Backing up existing /etc/nixos to /etc/nixos.backup..."
    sudo cp -r /etc/nixos /etc/nixos.backup || print_warning "Failed to backup existing configuration"
fi

# Generate hardware configuration
print_info "Generating hardware configuration..."
sudo nixos-generate-config --root /tmp/nixos-config 2>/dev/null || true
if [ -f /tmp/nixos-config/etc/nixos/hardware-configuration.nix ]; then
    cp /tmp/nixos-config/etc/nixos/hardware-configuration.nix "$SCRIPT_DIR/hosts/default/"
    print_success "Hardware configuration generated"
else
    print_warning "Could not generate hardware configuration. You'll need to copy it manually."
fi

# Update flake.nix with the correct hostname and username
print_info "Updating flake.nix..."
sed -i.bak "s/nixos = nixpkgs.lib.nixosSystem/$HOSTNAME = nixpkgs.lib.nixosSystem/" "$SCRIPT_DIR/flake.nix"
sed -i.bak "s/home-manager.users.jager/home-manager.users.$USERNAME/" "$SCRIPT_DIR/flake.nix"
sed -i.bak "s/\"jager@nixos\"/\"$USERNAME@$HOSTNAME\"/" "$SCRIPT_DIR/flake.nix"

# Update configuration.nix
print_info "Updating configuration.nix..."
sed -i.bak "s/userName = \"jager\"/userName = \"$USERNAME\"/" "$SCRIPT_DIR/hosts/default/configuration.nix"
sed -i.bak "s/hostname = \"nixos\"/hostname = \"$HOSTNAME\"/" "$SCRIPT_DIR/hosts/default/configuration.nix"
sed -i.bak "s/desktop = \"gnome\"/desktop = \"$DESKTOP\"/" "$SCRIPT_DIR/hosts/default/configuration.nix"

# Update home.nix
print_info "Updating home.nix..."
sed -i.bak "s/username = \"jager\"/username = \"$USERNAME\"/" "$SCRIPT_DIR/hosts/default/home.nix"
sed -i.bak "s|homeDirectory = \"/home/jager\"|homeDirectory = \"/home/$USERNAME\"|" "$SCRIPT_DIR/hosts/default/home.nix"

# Update system.nix timezone
print_info "Updating system timezone..."
sed -i.bak "s|default = \"America/New_York\"|default = \"$TIMEZONE\"|" "$SCRIPT_DIR/modules/nixos/system.nix"

# Update main-user.nix
print_info "Updating user configuration..."
sed -i.bak "s/userFullName = \"Main User\"/userFullName = \"$FULLNAME\"/" "$SCRIPT_DIR/modules/nixos/main-user.nix"

# Update git configuration
print_info "Updating git configuration..."
sed -i.bak "s/userName = \"Your Name\"/userName = \"$FULLNAME\"/" "$SCRIPT_DIR/modules/home-manager/git.nix"
sed -i.bak "s/userEmail = \"your.email@example.com\"/userEmail = \"$EMAIL\"/" "$SCRIPT_DIR/modules/home-manager/git.nix"

# Copy configuration to /etc/nixos
print_info "Copying configuration to /etc/nixos..."
sudo cp -r "$SCRIPT_DIR"/* /etc/nixos/
sudo chown -R root:root /etc/nixos

# Enable flakes if not already enabled
print_info "Ensuring flakes are enabled..."
sudo mkdir -p /etc/nix
if ! grep -q "experimental-features.*flakes" /etc/nix/nix.conf 2>/dev/null; then
    echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
    print_success "Flakes enabled"
else
    print_info "Flakes already enabled"
fi

print_success "Configuration setup complete!"
print_info ""
print_info "Next steps:"
print_info "1. Review the configuration files in /etc/nixos"
print_info "2. Run: sudo nixos-rebuild switch --flake /etc/nixos#$HOSTNAME"
print_info "3. Reboot your system"
print_info "4. Change your password after first login: passwd"
print_info ""
print_info "To rebuild in the future:"
print_info "  cd /etc/nixos && sudo nixos-rebuild switch --flake .#$HOSTNAME"

read -p "Would you like to rebuild now? (y/N): " REBUILD
if [[ $REBUILD =~ ^[Yy]$ ]]; then
    print_info "Starting rebuild..."
    cd /etc/nixos
    sudo nixos-rebuild switch --flake ".#$HOSTNAME"
    print_success "Rebuild complete! You may want to reboot now."
else
    print_info "Remember to rebuild when you're ready: sudo nixos-rebuild switch --flake /etc/nixos#$HOSTNAME"
fi
