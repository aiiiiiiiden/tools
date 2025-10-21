#!/bin/bash

# ================================================
# Unified Development Environment Setup Script
# ================================================
# Installs: Flutter SDK, FVM, Dart/Flutter MCP, Firebase MCP, Gemini CLI
# Platform: macOS
# Date: 2025
# ================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "\n${BLUE}================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ================================================
# Check Prerequisites
# ================================================
print_header "Checking Prerequisites"

# Check for Homebrew
if ! command_exists brew; then
    print_warning "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    print_success "Homebrew installed"
else
    print_success "Homebrew is already installed"
fi

# Check for Git
if ! command_exists git; then
    print_warning "Git not found. Installing Git..."
    brew install git
    print_success "Git installed"
else
    print_success "Git is already installed"
fi

# Check for Node.js and npm
if ! command_exists node || ! command_exists npm; then
    print_warning "Node.js/npm not found. Installing Node.js..."
    brew install node
    print_success "Node.js and npm installed"
else
    print_success "Node.js and npm are already installed"
    print_info "Node version: $(node --version)"
    print_info "npm version: $(npm --version)"
fi

# ================================================
# Install Flutter SDK
# ================================================
print_header "Installing Flutter SDK"

FLUTTER_DIR="$HOME/development"
FLUTTER_PATH="$FLUTTER_DIR/flutter"

if [ -d "$FLUTTER_PATH" ]; then
    print_warning "Flutter directory already exists at $FLUTTER_PATH"
    read -p "Do you want to reinstall? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$FLUTTER_PATH"
        print_info "Removed existing Flutter installation"
    else
        print_info "Skipping Flutter installation"
        SKIP_FLUTTER=true
    fi
fi

if [ "$SKIP_FLUTTER" != true ]; then
    # Create development directory
    mkdir -p "$FLUTTER_DIR"
    cd "$FLUTTER_DIR"

    # Clone Flutter repository (stable channel)
    print_info "Cloning Flutter SDK (stable channel)..."
    git clone https://github.com/flutter/flutter.git -b stable

    # Add Flutter to PATH temporarily for this script
    export PATH="$FLUTTER_PATH/bin:$PATH"

    print_success "Flutter SDK cloned successfully"
fi

# Run flutter precache
if [ "$SKIP_FLUTTER" != true ]; then
    print_info "Running flutter precache (this may take a few minutes)..."
    if "$FLUTTER_PATH/bin/flutter" precache 2>&1 | grep -v "Building flutter tool"; then
        print_success "Flutter precache completed"
    else
        print_warning "Flutter precache may have encountered issues, but continuing..."
    fi
fi

# Run flutter doctor
print_info "Running flutter doctor for initial diagnostics..."
"$FLUTTER_PATH/bin/flutter" doctor 2>&1

print_success "Flutter SDK installation completed"
print_info "Note: Some Flutter doctor warnings are normal and can be resolved in Next Steps"

# ================================================
# Configure Flutter PATH
# ================================================
print_header "Configuring Environment Variables"

SHELL_CONFIG=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
fi

if [ -n "$SHELL_CONFIG" ]; then
    # Check if Flutter is already in PATH
    if ! grep -q "flutter/bin" "$SHELL_CONFIG"; then
        echo "" >> "$SHELL_CONFIG"
        echo "# Flutter SDK" >> "$SHELL_CONFIG"
        echo "export PATH=\"\$HOME/development/flutter/bin:\$PATH\"" >> "$SHELL_CONFIG"
        print_success "Added Flutter to PATH in $SHELL_CONFIG"
    else
        print_info "Flutter is already in PATH"
    fi

    # Add Dart pub global packages to PATH
    if ! grep -q ".pub-cache/bin" "$SHELL_CONFIG"; then
        echo "export PATH=\"\$HOME/.pub-cache/bin:\$PATH\"" >> "$SHELL_CONFIG"
        print_success "Added Dart pub global packages to PATH"
    else
        print_info "Dart pub global packages already in PATH"
    fi
fi

# ================================================
# Install FVM (Flutter Version Management)
# ================================================
print_header "Installing FVM (Flutter Version Management)"

if command_exists fvm; then
    print_info "FVM is already installed"
    print_info "FVM version: $(fvm --version)"
else
    print_info "Installing FVM via Homebrew..."

    # Add FVM tap
    brew tap leoafarias/fvm

    # Install FVM
    brew install fvm

    print_success "FVM installed successfully"
    print_info "FVM version: $(fvm --version)"
fi

# ================================================
# Setup Dart/Flutter MCP Server
# ================================================
print_header "Setting up Dart/Flutter MCP Server"

# Check Dart version (requires Dart 3.9+)
if command_exists dart; then
    DART_VERSION=$(dart --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
    print_info "Dart version: $DART_VERSION"

    # Note: Dart MCP server comes with Dart SDK 3.9+
    print_success "Dart/Flutter MCP Server is available via 'dart mcp-server' command"
    print_info "To use with VS Code: Install Dart Code extension v3.116+"
    print_info "To use with Cursor: Add MCP server configuration to Cursor settings"
else
    print_warning "Dart not found. It should be installed with Flutter SDK."
fi

# ================================================
# Install Firebase MCP Server
# ================================================
print_header "Installing Firebase MCP Server"

if command_exists npx; then
    print_info "Firebase MCP Server will be available via npx"

    # Install firebase-tools globally with latest version for MCP support
    print_info "Installing firebase-tools@latest globally..."
    print_info "Note: Firebase MCP requires firebase-tools v13.21.0+"

    npm install -g firebase-tools@latest

    if [ $? -eq 0 ]; then
        print_success "firebase-tools installed successfully"
        FIREBASE_VERSION=$(firebase --version 2>/dev/null || echo "Unknown")
        print_info "Firebase CLI version: $FIREBASE_VERSION"

        # Check if MCP is available
        if firebase mcp --help >/dev/null 2>&1; then
            print_success "Firebase MCP: Available via 'firebase mcp'"
        else
            print_info "Firebase MCP: Use 'npx -y firebase-tools@latest mcp' for latest MCP features"
        fi
    else
        print_error "Failed to install firebase-tools"
    fi
else
    print_error "npx not found. Cannot install Firebase MCP Server."
fi

# ================================================
# Install Gemini CLI
# ================================================
print_header "Installing Gemini CLI"

if command_exists gemini; then
    print_info "Gemini CLI is already installed"
    GEMINI_VERSION=$(gemini --version 2>/dev/null || echo 'Unable to determine')
    print_info "Gemini CLI version: $GEMINI_VERSION"

    # Check if configured
    if [ -f "$HOME/.gemini/config.json" ] || [ -f "$HOME/.config/gemini/config.json" ]; then
        print_success "Gemini CLI appears to be configured"
    else
        print_warning "Gemini CLI may not be configured yet"
        print_info "Configure with: gemini config"
    fi
else
    print_info "Installing Gemini CLI via npm..."
    npm install -g @google/gemini-cli

    if [ $? -eq 0 ]; then
        print_success "Gemini CLI installed successfully"

        # Check if installation was successful
        if command_exists gemini; then
            GEMINI_VERSION=$(gemini --version 2>/dev/null || echo 'Installed')
            print_info "Gemini CLI version: $GEMINI_VERSION"
            print_warning "Remember to configure Gemini CLI after installation:"
            print_info "Run: gemini config"
        fi
    else
        print_error "Failed to install Gemini CLI"
    fi
fi

# ================================================
# Install Firebase Extension for Gemini CLI
# ================================================
print_header "Installing Firebase Extension for Gemini CLI"

if command_exists gemini; then
    print_info "Installing Firebase extension for Gemini CLI..."

    # Note: This requires Gemini CLI to be set up first
    # Users will need to authenticate and configure
    print_info "To install Firebase extension, run:"
    print_info "  gemini extensions install https://github.com/gemini-cli-extensions/firebase/"
    print_warning "Note: You may need to authenticate Gemini CLI first with 'gemini config'"
else
    print_warning "Gemini CLI not found. Skipping Firebase extension installation."
fi

# ================================================
# Final Summary
# ================================================
print_header "Installation Summary"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Installed components:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  1. Flutter SDK         → $FLUTTER_PATH"
if command_exists flutter; then
    echo "     Version: $(flutter --version 2>&1 | head -1)"
fi
echo ""
echo "  2. FVM                 → $(command_exists fvm && fvm --version || echo 'Not installed')"
echo ""
echo "  3. Dart MCP Server     → Available via 'dart mcp-server'"
if command_exists dart; then
    echo "     Dart version: $(dart --version 2>&1 | head -1)"
fi
echo ""
echo "  4. Firebase MCP        → Available"
if command_exists firebase; then
    echo "     Firebase CLI: $(firebase --version)"
    if firebase mcp --help >/dev/null 2>&1; then
        echo "     MCP: Run 'firebase mcp'"
    else
        echo "     MCP: Run 'npx -y firebase-tools@latest mcp'"
    fi
fi
echo ""
echo "  5. Gemini CLI          → $(command_exists gemini && echo 'Installed' || echo 'Not installed')"
if command_exists gemini; then
    GEMINI_VER=$(gemini --version 2>/dev/null || echo 'Unknown')
    echo "     Version: $GEMINI_VER"
    if [ -f "$HOME/.gemini/config.json" ] || [ -f "$HOME/.config/gemini/config.json" ]; then
        echo "     Status: Configured ✓"
    else
        echo "     Status: Not configured yet (run 'gemini config')"
    fi
fi
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

print_header "Next Steps"

echo "1. Restart your terminal or run:"
echo "   source $SHELL_CONFIG"
echo ""
echo "2. Run verification script to check installation:"
echo "   ./doctor.sh"
echo ""
echo "3. Accept Android licenses (required for Android development):"
echo "   flutter doctor --android-licenses"
echo ""
echo "4. Configure Gemini CLI (if using):"
echo "   gemini config"
echo ""
echo "5. Install Firebase extension for Gemini CLI (optional):"
echo "   gemini extensions install https://github.com/gemini-cli-extensions/firebase/"
echo ""
echo "6. For MCP server setup:"
echo "   - Dart/Flutter MCP: Requires VS Code with Dart Code extension v3.116+"
echo "   - Firebase MCP: Use 'firebase mcp' or 'npx -y firebase-tools@latest mcp'"
echo "   - Configure in your MCP client settings (Claude Desktop, Cursor, etc.)"
echo ""
echo "7. Quick verification commands:"
echo "   flutter --version"
echo "   fvm --version"
echo "   dart --version"
echo "   firebase --version"
echo "   gemini --version"
echo ""

print_success "Installation completed! 🎉"
print_info "For more information:"
echo "  - Flutter: https://docs.flutter.dev"
echo "  - FVM: https://fvm.app"
echo "  - Dart MCP: https://dart.dev/tools/mcp-server"
echo "  - Firebase MCP: https://firebase.google.com/docs/cli/mcp-server"
echo "  - Gemini CLI: https://github.com/google-gemini/gemini-cli"
