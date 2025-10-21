#!/bin/bash

# ================================================
# Development Environment Verification Script
# ================================================
# Verifies: Flutter SDK, FVM, Dart/Flutter MCP, Firebase MCP, Gemini CLI
# Platform: macOS
# Date: 2025
# ================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0
WARNINGS=0

# Helper functions
print_header() {
    echo -e "\n${BLUE}================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
    ((PASSED++))
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
    ((FAILED++))
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
    ((WARNINGS++))
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

check_path_contains() {
    echo "$PATH" | grep -q "$1"
}

# ================================================
# Check Prerequisites
# ================================================
print_header "Checking Prerequisites"

# Check for Homebrew
if command_exists brew; then
    BREW_VERSION=$(brew --version | head -1)
    print_success "Homebrew: $BREW_VERSION"
else
    print_error "Homebrew: Not found"
    print_info "Install with: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
fi

# Check for Git
if command_exists git; then
    GIT_VERSION=$(git --version)
    print_success "Git: $GIT_VERSION"
else
    print_error "Git: Not found"
    print_info "Install with: brew install git"
fi

# Check for Node.js
if command_exists node; then
    NODE_VERSION=$(node --version)
    print_success "Node.js: $NODE_VERSION"
else
    print_error "Node.js: Not found"
    print_info "Install with: brew install node"
fi

# Check for npm
if command_exists npm; then
    NPM_VERSION=$(npm --version)
    print_success "npm: v$NPM_VERSION"
else
    print_error "npm: Not found"
    print_info "Install with Node.js: brew install node"
fi

# ================================================
# Check Flutter SDK
# ================================================
print_header "Checking Flutter SDK"

FLUTTER_DIR="$HOME/development"
FLUTTER_PATH="$FLUTTER_DIR/flutter"

# Check if Flutter directory exists
if [ -d "$FLUTTER_PATH" ]; then
    print_success "Flutter directory exists: $FLUTTER_PATH"
else
    print_error "Flutter directory not found: $FLUTTER_PATH"
    print_info "Expected location: $FLUTTER_PATH"
fi

# Check if Flutter command is available
if command_exists flutter; then
    FLUTTER_VERSION=$(flutter --version | head -1)
    print_success "Flutter command: $FLUTTER_VERSION"

    # Get Flutter channel
    FLUTTER_CHANNEL=$(flutter channel | grep -E '^\*' | awk '{print $2}')
    print_info "Flutter channel: $FLUTTER_CHANNEL"
else
    print_error "Flutter command: Not found in PATH"
    print_info "Add to PATH: export PATH=\"\$HOME/development/flutter/bin:\$PATH\""
fi

# Check if Flutter is in PATH
if check_path_contains "flutter/bin"; then
    print_success "Flutter is in PATH"
else
    print_warning "Flutter is not in PATH"
    print_info "Add to ~/.zshrc: export PATH=\"\$HOME/development/flutter/bin:\$PATH\""
fi

# Check Dart
if command_exists dart; then
    DART_VERSION=$(dart --version 2>&1 | head -1)
    print_success "Dart: $DART_VERSION"
else
    print_error "Dart: Not found"
    print_info "Dart should be installed with Flutter SDK"
fi

# ================================================
# Check Dart pub-cache PATH
# ================================================
print_header "Checking Dart pub-cache Configuration"

if check_path_contains ".pub-cache/bin"; then
    print_success "Dart pub-cache is in PATH"
else
    print_warning "Dart pub-cache is not in PATH"
    print_info "Add to ~/.zshrc: export PATH=\"\$HOME/.pub-cache/bin:\$PATH\""
fi

# ================================================
# Check FVM (Flutter Version Management)
# ================================================
print_header "Checking FVM"

if command_exists fvm; then
    FVM_VERSION=$(fvm --version)
    print_success "FVM: $FVM_VERSION"

    # Check installed Flutter versions via FVM
    print_info "Checking FVM Flutter versions..."
    FVM_LIST=$(fvm list 2>/dev/null)
    if [ -n "$FVM_LIST" ]; then
        echo "$FVM_LIST"
    else
        print_info "No Flutter versions installed via FVM yet"
    fi
else
    print_error "FVM: Not found"
    print_info "Install with: brew tap leoafarias/fvm && brew install fvm"
fi

# ================================================
# Check Dart MCP Server
# ================================================
print_header "Checking Dart MCP Server"

if command_exists dart; then
    # Check if dart mcp-server command is available
    if dart mcp-server --help >/dev/null 2>&1; then
        print_success "Dart MCP Server: Available"
        print_info "Run with: dart mcp-server"
    else
        print_warning "Dart MCP Server: Command not available"
        print_info "Requires Dart SDK 3.9+"
    fi
else
    print_error "Dart MCP Server: Cannot check (Dart not found)"
fi

# ================================================
# Check Firebase CLI and MCP
# ================================================
print_header "Checking Firebase CLI and MCP"

if command_exists firebase; then
    FIREBASE_VERSION=$(firebase --version)
    print_success "Firebase CLI: $FIREBASE_VERSION"

    # Check if Firebase MCP is available
    if firebase mcp --help >/dev/null 2>&1; then
        print_success "Firebase MCP: Available via installed CLI"
        print_info "Run with: firebase mcp"
    else
        print_info "Firebase MCP: Not available in current version"
        print_info "Firebase MCP requires firebase-tools v13.21.0+"

        # Check if we can run via npx
        if command_exists npx; then
            print_info "Checking via npx (this may take a moment)..."
            if timeout 10 npx -y firebase-tools@latest --version >/dev/null 2>&1; then
                print_success "Firebase MCP: Available via npx"
                print_info "Run with: npx -y firebase-tools@latest mcp"
            else
                print_warning "Unable to verify npx access (network/timeout)"
                print_info "Try: npx -y firebase-tools@latest mcp"
            fi
        fi
    fi
else
    print_error "Firebase CLI: Not found"
    print_info "Install with: npm install -g firebase-tools"
fi

# Check npx
if command_exists npx; then
    print_success "npx: Available"
else
    print_error "npx: Not found (should be installed with npm)"
fi

# ================================================
# Check Gemini CLI
# ================================================
print_header "Checking Gemini CLI"

if command_exists gemini; then
    GEMINI_VERSION=$(gemini --version 2>/dev/null || echo "Installed (version unavailable)")
    print_success "Gemini CLI: $GEMINI_VERSION"

    # Check if Gemini is configured
    if [ -f "$HOME/.gemini/config.json" ] || [ -f "$HOME/.config/gemini/config.json" ]; then
        print_info "Gemini CLI appears to be configured"
    else
        print_warning "Gemini CLI may not be configured yet"
        print_info "Configure with: gemini config"
    fi
else
    print_error "Gemini CLI: Not found"
    print_info "Install with: npm install -g @google/gemini-cli"
fi

# ================================================
# Run Flutter Doctor
# ================================================
print_header "Running Flutter Doctor"

if command_exists flutter; then
    print_info "Running comprehensive Flutter diagnostics...\n"

    # Capture flutter doctor output to check for issues
    DOCTOR_OUTPUT=$(flutter doctor -v 2>&1)
    echo "$DOCTOR_OUTPUT"
    echo ""

    # Check for common issues
    print_info "Checking for common Flutter setup issues..."

    # Check Android licenses
    if echo "$DOCTOR_OUTPUT" | grep -q "Android licenses"; then
        print_warning "Android licenses need to be accepted"
        print_info "Run: flutter doctor --android-licenses"
    fi
else
    print_error "Cannot run flutter doctor - Flutter not found"
fi

# ================================================
# Check Shell Configuration
# ================================================
print_header "Checking Shell Configuration"

SHELL_CONFIG=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
    print_success "Shell config found: ~/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
    print_success "Shell config found: ~/.bashrc"
else
    print_warning "No shell config file found"
fi

if [ -n "$SHELL_CONFIG" ]; then
    # Check Flutter PATH in config
    if grep -q "flutter/bin" "$SHELL_CONFIG"; then
        print_success "Flutter PATH found in $SHELL_CONFIG"
    else
        print_warning "Flutter PATH not found in $SHELL_CONFIG"
        print_info "Add: export PATH=\"\$HOME/development/flutter/bin:\$PATH\""
    fi

    # Check pub-cache PATH in config
    if grep -q ".pub-cache/bin" "$SHELL_CONFIG"; then
        print_success "Dart pub-cache PATH found in $SHELL_CONFIG"
    else
        print_warning "Dart pub-cache PATH not found in $SHELL_CONFIG"
        print_info "Add: export PATH=\"\$HOME/.pub-cache/bin:\$PATH\""
    fi
fi

# ================================================
# Summary
# ================================================
print_header "Verification Summary"

TOTAL=$((PASSED + FAILED + WARNINGS))

echo -e "${GREEN}Passed:   $PASSED${NC}"
echo -e "${RED}Failed:   $FAILED${NC}"
echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
echo -e "Total:    $TOTAL"
echo ""

if [ $FAILED -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✓ All checks passed!${NC}"
    echo -e "${GREEN}✓ Your development environment is properly configured.${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    exit 0
elif [ $FAILED -eq 0 ]; then
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}⚠ All critical checks passed with some warnings.${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${BLUE}Common warnings and how to fix them:${NC}"
    echo ""
    echo -e "${YELLOW}• Firebase MCP not available:${NC}"
    echo -e "  → Update: npm install -g firebase-tools@latest"
    echo -e "  → Or use: npx -y firebase-tools@latest mcp"
    echo ""
    echo -e "${YELLOW}• Gemini CLI not configured:${NC}"
    echo -e "  → Configure: gemini config"
    echo ""
    echo -e "${YELLOW}• Android licenses not accepted:${NC}"
    echo -e "  → Accept: flutter doctor --android-licenses"
    echo ""
    exit 0
else
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}✗ Some checks failed!${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo -e "1. Review the errors above"
    echo -e "2. Run ./install.sh to install missing components"
    echo -e "3. Restart your terminal or run: source $SHELL_CONFIG"
    echo -e "4. Run ./doctor.sh again to verify"
    echo ""
    exit 1
fi
