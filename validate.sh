#!/usr/bin/env bash

# 🔍 Pre-NixOS Configuration Validator
# Validates your configuration structure before deploying to NixOS

set -e

# Colors and emojis
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SUCCESS="✅"
ERROR="❌"
WARNING="⚠️"
INFO="ℹ️"

print_header() {
    echo -e "${BLUE}🔍 $1${NC}"
    echo "$(printf '=%.0s' {1..50})"
}

print_success() {
    echo -e "${GREEN}${SUCCESS} $1${NC}"
}

print_error() {
    echo -e "${RED}${ERROR} $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}${WARNING} $1${NC}"
}

print_info() {
    echo -e "${BLUE}${INFO} $1${NC}"
}

# Check functions
check_file_exists() {
    local file="$1"
    local description="$2"
    
    if [[ -f "$file" ]]; then
        print_success "$description exists: $file"
        return 0
    else
        print_error "$description missing: $file"
        return 1
    fi
}

check_directory_exists() {
    local dir="$1"
    local description="$2"
    
    if [[ -d "$dir" ]]; then
        print_success "$description exists: $dir"
        return 0
    else
        print_error "$description missing: $dir"
        return 1
    fi
}

check_executable() {
    local file="$1"
    local description="$2"
    
    if [[ -x "$file" ]]; then
        print_success "$description is executable: $file"
        return 0
    else
        print_warning "$description is not executable: $file"
        return 1
    fi
}

# Main validation
main() {
    print_header "Configuration Structure Validation"
    
    local errors=0
    
    # Core files
    echo -e "\n${INFO} Checking core configuration files..."
    check_file_exists "flake.nix" "Main flake configuration" || ((errors++))
    check_file_exists "flake.lock" "Flake lock file" || ((errors++))
    check_file_exists "README.md" "Main documentation" || ((errors++))
    
    # Scripts
    echo -e "\n${INFO} Checking automation scripts..."
    check_file_exists "setup.sh" "Setup script" || ((errors++))
    check_executable "setup.sh" "Setup script"
    check_file_exists "test.sh" "Test script" || ((errors++))
    check_executable "test.sh" "Test script"
    check_file_exists "Makefile" "Makefile" || ((errors++))
    
    # Directory structure
    echo -e "\n${INFO} Checking directory structure..."
    check_directory_exists "hosts" "Hosts directory" || ((errors++))
    check_directory_exists "hosts/default" "Default host directory" || ((errors++))
    check_directory_exists "modules" "Modules directory" || ((errors++))
    check_directory_exists "modules/nixos" "NixOS modules directory" || ((errors++))
    check_directory_exists "modules/home-manager" "Home-manager modules directory" || ((errors++))
    check_directory_exists ".github" "GitHub configuration directory" || ((errors++))
    check_directory_exists ".github/workflows" "GitHub workflows directory" || ((errors++))
    
    # Host configuration files
    echo -e "\n${INFO} Checking host configuration files..."
    check_file_exists "hosts/default/configuration.nix" "Main system configuration" || ((errors++))
    check_file_exists "hosts/default/hardware-configuration.nix" "Hardware configuration" || ((errors++))
    check_file_exists "hosts/default/home.nix" "Home-manager configuration" || ((errors++))
    
    # NixOS modules
    echo -e "\n${INFO} Checking NixOS modules..."
    check_file_exists "modules/nixos/main-user.nix" "Main user module" || ((errors++))
    check_file_exists "modules/nixos/system.nix" "System module" || ((errors++))
    check_file_exists "modules/nixos/desktop.nix" "Desktop module" || ((errors++))
    check_file_exists "modules/nixos/optional-services.nix" "Optional services module" || ((errors++))
    
    # Home-manager modules
    echo -e "\n${INFO} Checking home-manager modules..."
    check_file_exists "modules/home-manager/packages.nix" "Packages module" || ((errors++))
    check_file_exists "modules/home-manager/shell.nix" "Shell module" || ((errors++))
    check_file_exists "modules/home-manager/git.nix" "Git module" || ((errors++))
    check_file_exists "modules/home-manager/development.nix" "Development module" || ((errors++))
    
    # GitHub workflows
    echo -e "\n${INFO} Checking GitHub workflows..."
    check_file_exists ".github/workflows/ci.yml" "CI workflow" || ((errors++))
    check_file_exists ".github/workflows/update.yml" "Update workflow" || ((errors++))
    check_file_exists ".github/workflows/release.yml" "Release workflow" || ((errors++))
    check_file_exists ".github/workflows/bot.yml" "Bot workflow" || ((errors++))
    check_file_exists ".github/workflows/issue-management.yml" "Issue management workflow" || ((errors++))
    
    # Development environment
    echo -e "\n${INFO} Checking development environment..."
    check_file_exists "shell.nix" "Development shell" || ((errors++))
    check_file_exists ".envrc" "Direnv configuration" || ((errors++))
    check_file_exists ".pre-commit-config.yaml" "Pre-commit configuration" || ((errors++))
    check_file_exists ".gitignore" "Git ignore file" || ((errors++))
    
    # Templates and documentation
    echo -e "\n${INFO} Checking templates and documentation..."
    check_file_exists ".github/PULL_REQUEST_TEMPLATE/pull_request_template.md" "PR template" || ((errors++))
    check_file_exists ".github/CONTRIBUTING.md" "Contributing guidelines" || ((errors++))
    check_file_exists ".github/SECURITY.md" "Security policy" || ((errors++))
    check_file_exists "LICENSE" "License file" || ((errors++))
    
    # Content validation
    echo -e "\n${INFO} Checking configuration content..."
    
    # Check if hardware-configuration.nix is still the template
    if grep -q "# This is a template" hosts/default/hardware-configuration.nix 2>/dev/null; then
        print_warning "Hardware configuration is still a template - replace with actual hardware config"
    else
        print_success "Hardware configuration appears to be customized"
    fi
    
    # Check for placeholder usernames
    if grep -q "jager" flake.nix 2>/dev/null; then
        print_warning "Found placeholder username 'jager' in flake.nix - consider personalizing"
    fi
    
    # Check git configuration
    if grep -q "Your Name" modules/home-manager/git.nix 2>/dev/null; then
        print_warning "Git configuration has placeholder values - consider personalizing"
    fi
    
    # Summary
    echo -e "\n$(printf '=%.0s' {1..50})"
    print_header "Validation Summary"
    
    if [[ $errors -eq 0 ]]; then
        print_success "All checks passed! Configuration structure is valid."
        echo -e "\n${INFO} Next steps:"
        echo "  1. Run './setup.sh' to personalize your configuration"
        echo "  2. Initialize git repository: git init && git add . && git commit -m 'Initial commit'"
        echo "  3. Deploy to NixOS system when ready"
        echo "  4. See README.md and docs/ for detailed instructions"
        return 0
    else
        print_error "$errors validation errors found. Please fix before proceeding."
        return 1
    fi
}

# Help
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "🔍 Pre-NixOS Configuration Validator"
    echo ""
    echo "This script validates your NixOS configuration structure"
    echo "before deploying to an actual NixOS system."
    echo ""
    echo "Usage: $0"
    echo ""
    echo "The script checks:"
    echo "  - Configuration file structure"
    echo "  - Required modules and scripts"
    echo "  - GitHub workflows and templates"
    echo "  - Development environment setup"
    echo ""
    exit 0
fi

main
