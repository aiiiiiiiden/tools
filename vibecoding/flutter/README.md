# Flutter Development Environment Setup

Automated setup and verification scripts for Flutter development environment on macOS.

## Overview

This directory contains two main scripts to streamline your Flutter development environment setup:

- **`install.sh`** - Automated installation script for Flutter SDK and related tools
- **`doctor.sh`** - Comprehensive verification script to validate your setup

## What Gets Installed

The `install.sh` script installs and configures the following tools:

1. **Flutter SDK** - Latest stable version
2. **FVM (Flutter Version Management)** - Manage multiple Flutter versions
3. **Dart MCP Server** - Model Context Protocol server for Dart/Flutter
4. **Firebase MCP** - Firebase integration via MCP
5. **Gemini CLI** - Google's Gemini AI command-line interface

### Prerequisites

The script will automatically install these if missing:
- Homebrew
- Git
- Node.js and npm

## Installation

### Quick Start

1. Make the scripts executable:
```bash
chmod +x install.sh doctor.sh
```

2. Run the installation script:
```bash
./install.sh
```

3. Restart your terminal or reload your shell configuration:
```bash
source ~/.zshrc  # for zsh
# or
source ~/.bashrc  # for bash
```

4. Verify the installation:
```bash
./doctor.sh
```

### What install.sh Does

The installation script performs the following steps:

1. **Checks prerequisites** and installs if needed:
   - Homebrew
   - Git
   - Node.js/npm

2. **Installs Flutter SDK**:
   - Clones Flutter repository (stable channel)
   - Installs to `~/development/flutter`
   - Runs initial setup and precache
   - Configures PATH in your shell config

3. **Installs FVM**:
   - Adds FVM tap to Homebrew
   - Installs via Homebrew

4. **Sets up Dart/Flutter MCP Server**:
   - Verifies Dart version (requires 3.9+)
   - Enables MCP server functionality

5. **Installs Firebase MCP**:
   - Installs firebase-tools globally
   - Requires version 13.21.0+ for MCP support

6. **Installs Gemini CLI**:
   - Installs via npm globally
   - Provides setup instructions

7. **Configures environment**:
   - Adds Flutter to PATH
   - Adds Dart pub-cache to PATH
   - Updates `.zshrc` or `.bashrc`

### Interactive Installation

The script will:
- Prompt before reinstalling existing Flutter installation
- Display colored output for easy reading
- Show progress for long-running operations
- Provide clear error messages and suggestions

## Verification

### Using doctor.sh

After installation, run the verification script:

```bash
./doctor.sh
```

### What doctor.sh Checks

The verification script performs comprehensive checks:

1. **Prerequisites**:
   - Homebrew
   - Git
   - Node.js
   - npm

2. **Flutter SDK**:
   - Installation directory
   - Command availability
   - PATH configuration
   - Current channel

3. **Dart**:
   - Version
   - pub-cache PATH configuration

4. **FVM**:
   - Installation
   - Installed Flutter versions

5. **MCP Servers**:
   - Dart MCP Server availability
   - Firebase MCP availability

6. **Gemini CLI**:
   - Installation
   - Configuration status

7. **Shell Configuration**:
   - PATH entries in `.zshrc`/`.bashrc`

8. **Flutter Doctor**:
   - Runs full `flutter doctor -v`
   - Checks for common issues

### Understanding the Results

The script shows:
- ✓ **Green checks**: Everything working correctly
- ⚠ **Yellow warnings**: Non-critical issues
- ✗ **Red errors**: Critical problems requiring attention

### Exit Codes

- `0`: All checks passed
- `1`: Some checks failed

## Post-Installation Steps

After successful installation, complete these steps:

### 1. Accept Android Licenses

If you plan to develop for Android:

```bash
flutter doctor --android-licenses
```

### 2. Configure Gemini CLI

If you installed Gemini CLI:

```bash
gemini config
```

### 3. Install Firebase Extension (Optional)

For Gemini CLI Firebase integration:

```bash
gemini extensions install https://github.com/gemini-cli-extensions/firebase/
```

### 4. Configure MCP Servers

To use MCP servers with your editor or IDE:

- **Dart/Flutter MCP**: Requires VS Code with Dart Code extension v3.116+
- **Firebase MCP**: Configure in Claude Desktop, Cursor, or other MCP clients

Example MCP configuration for Claude Desktop (`~/Library/Application Support/Claude/claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "dart": {
      "command": "dart",
      "args": ["mcp-server"]
    },
    "firebase": {
      "command": "npx",
      "args": ["-y", "firebase-tools@latest", "mcp"]
    }
  }
}
```

### 5. Verify Everything Works

Run quick verification commands:

```bash
flutter --version
fvm --version
dart --version
firebase --version
gemini --version
```

## Using FVM

FVM allows you to manage multiple Flutter versions:

### Install a specific Flutter version:
```bash
fvm install 3.24.0
```

### Use a version globally:
```bash
fvm global 3.24.0
```

### Use a version for a specific project:
```bash
cd your-flutter-project
fvm use 3.24.0
```

### List installed versions:
```bash
fvm list
```

## Troubleshooting

### Flutter command not found

After installation, if `flutter` command is not found:

1. Restart your terminal
2. Or reload your shell config:
   ```bash
   source ~/.zshrc  # or ~/.bashrc
   ```

3. Verify PATH is configured:
   ```bash
   echo $PATH | grep flutter
   ```

### Permission Issues

If you encounter permission errors:

```bash
chmod +x install.sh doctor.sh
```

### Network Issues

If downloads fail:
- Check your internet connection
- Try again (the script is idempotent)
- Use a VPN if accessing GitHub is restricted

### Dart MCP Server Not Available

Requires Dart SDK 3.9+. Update Flutter:

```bash
flutter upgrade
dart --version
```

### Firebase MCP Not Available

Update to latest firebase-tools:

```bash
npm install -g firebase-tools@latest
```

Or use via npx:

```bash
npx -y firebase-tools@latest mcp
```

## Uninstallation

To remove the Flutter installation:

```bash
# Remove Flutter SDK
rm -rf ~/development/flutter

# Remove FVM
brew uninstall fvm
brew untap leoafarias/fvm

# Remove global npm packages
npm uninstall -g firebase-tools @google/gemini-cli

# Remove PATH entries from shell config
# Edit ~/.zshrc or ~/.bashrc and remove Flutter-related PATH exports
```

## Resources

- **Flutter**: https://docs.flutter.dev
- **FVM**: https://fvm.app
- **Dart MCP**: https://dart.dev/tools/mcp-server
- **Firebase MCP**: https://firebase.google.com/docs/cli/mcp-server
- **Gemini CLI**: https://github.com/google-gemini/gemini-cli

## System Requirements

- **OS**: macOS (scripts are designed for macOS)
- **Disk Space**: ~2GB for Flutter SDK and tools
- **Internet**: Required for downloads

## License

These scripts are provided as-is for development environment setup.

## Contributing

Feel free to report issues or suggest improvements.
