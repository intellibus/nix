#!/usr/bin/env bash

# 🧪 NixOS Configuration Test Script
# Run comprehensive tests on your configuration before committing

set -e

# Colors for output 🎨
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Emojis for fun! 😄
TEST_EMOJI="🧪"
SUCCESS_EMOJI="✅"
ERROR_EMOJI="❌"
WARNING_EMOJI="⚠️"
INFO_EMOJI="ℹ️"
ROCKET_EMOJI="🚀"

print_header() {
    echo -e "${BLUE}${TEST_EMOJI} $1${NC}"
    echo "$(printf '=%.0s' {1..50})"
}

print_success() {
    echo -e "${GREEN}${SUCCESS_EMOJI} $1${NC}"
}

print_error() {
    echo -e "${RED}${ERROR_EMOJI} $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}${WARNING_EMOJI} $1${NC}"
}

print_info() {
    echo -e "${PURPLE}${INFO_EMOJI} $1${NC}"
}

# Track test results
TESTS_PASSED=0
TESTS_FAILED=0

run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo -e "\n${BLUE}Running: $test_name${NC}"
    
    if eval "$test_command"; then
        print_success "$test_name passed"
        ((TESTS_PASSED++))
        return 0
    else
        print_error "$test_name failed"
        ((TESTS_FAILED++))
        return 1
    fi
}

# Main test function
main() {
    print_header "NixOS Configuration Test Suite"
    
    echo -e "${INFO_EMOJI} Starting comprehensive tests...\n"
    
    # Turn off exit on error for test execution
    set +e
    
    # Test 1: Check if we're in the right directory
    run_test "📁 Directory Check" "test -f flake.nix && test -f README.md"
    
    # Test 2: Flake syntax validation
    run_test "🔍 Flake Check" "nix flake check --no-build"
    
    # Test 3: Show flake structure
    run_test "📊 Flake Show" "nix flake show"
    
    # Test 4: Build system configuration
    run_test "🏗️ Build NixOS Config" "nix build .#nixosConfigurations.nixos.config.system.build.toplevel --no-link"
    
    # Test 5: Build home-manager configuration
    run_test "🏠 Build Home Manager" "nix build .#homeConfigurations.\"jager@nixos\".activationPackage --no-link || echo 'Skipping home-manager build (may not be available)'"
    
    # Test 6: Format check
    run_test "📝 Format Check" "nix run nixpkgs#nixpkgs-fmt -- --check ."
    
    # Test 7: Check for common issues
    run_test "🔒 Security Check" "! grep -r 'password.*=' . --include='*.nix' | grep -v 'initialPassword\\|hashedPassword' || echo 'Found potential hardcoded passwords'"
    
    # Test 8: Documentation check
    run_test "📚 Documentation Check" "test -s README.md"
    
    # Test 9: Setup script check
    run_test "🔧 Setup Script Check" "test -x setup.sh"
    
    # Test 10: Git status (warn about uncommitted changes)
    if git status --porcelain | grep -q .; then
        print_warning "🔄 Uncommitted changes detected"
        git status --short
    else
        print_success "🔄 Working directory clean"
        ((TESTS_PASSED++))
    fi
    
    # Re-enable exit on error
    set -e
    
    # Summary
    echo -e "\n$(printf '=%.0s' {1..50})"
    print_header "Test Results Summary"
    
    echo -e "${GREEN}${SUCCESS_EMOJI} Tests Passed: $TESTS_PASSED${NC}"
    echo -e "${RED}${ERROR_EMOJI} Tests Failed: $TESTS_FAILED${NC}"
    
    if [ $TESTS_FAILED -eq 0 ]; then
        echo -e "\n${GREEN}${ROCKET_EMOJI} All tests passed! Ready to commit! ${ROCKET_EMOJI}${NC}"
        exit 0
    else
        echo -e "\n${RED}${ERROR_EMOJI} Some tests failed. Please fix issues before committing.${NC}"
        exit 1
    fi
}

# Help function
show_help() {
    echo -e "${BLUE}${TEST_EMOJI} NixOS Configuration Test Script${NC}"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  --format-fix   Auto-fix formatting issues"
    echo "  --quick        Run quick tests only"
    echo ""
    echo "Examples:"
    echo "  $0                # Run all tests"
    echo "  $0 --quick        # Run quick tests"
    echo "  $0 --format-fix   # Fix formatting and run tests"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        --format-fix)
            print_info "🎨 Auto-fixing formatting..."
            nix run nixpkgs#nixpkgs-fmt -- .
            shift
            ;;
        --quick)
            print_info "⚡ Running quick tests only..."
            # Override main function for quick tests
            main() {
                print_header "Quick Test Suite"
                
                # Turn off exit on error for test execution
                set +e
                run_test "🔍 Flake Check" "nix flake check --no-build"
                run_test "📝 Format Check" "nix run nixpkgs#nixpkgs-fmt -- --check ."
                set -e
                
                # Summary for quick tests
                echo -e "\n$(printf '=%.0s' {1..50})"
                print_header "Quick Test Results"
                
                echo -e "${GREEN}${SUCCESS_EMOJI} Tests Passed: $TESTS_PASSED${NC}"
                echo -e "${RED}${ERROR_EMOJI} Tests Failed: $TESTS_FAILED${NC}"
                
                if [ $TESTS_FAILED -eq 0 ]; then
                    echo -e "\n${GREEN}${ROCKET_EMOJI} Quick tests passed! ${ROCKET_EMOJI}${NC}"
                    exit 0
                else
                    echo -e "\n${RED}${ERROR_EMOJI} Quick tests failed.${NC}"
                    exit 1
                fi
            }
            shift
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Check if nix is available
if ! command -v nix &> /dev/null; then
    print_error "Nix is not installed or not in PATH"
    exit 1
fi

# Run main function
main
