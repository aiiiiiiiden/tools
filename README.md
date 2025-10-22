# Development Tools Collection

A curated collection of automation scripts and tools for streamlining development environment setup and workflows.

## 📋 Available Tools

### 🎯 Vibe Coding

Tools and utilities for vibe coding development environments.

#### Flutter Development Environment Setup
**Location:** `vibecoding/flutter/`

Automated installation and verification scripts for Flutter vibe coding environment on macOS.

**Features:**
- ✅ Automated installation of Flutter SDK via FVM
- ✅ Dart/Flutter MCP Server setup
- ✅ Firebase MCP integration
- ✅ Gemini CLI installation and configuration
- ✅ Environment verification with comprehensive health checks

**Quick Start:**
```bash
cd vibecoding/flutter
chmod +x install.sh doctor.sh
./install.sh
./doctor.sh
```

**Documentation:**
- [English Setup Guide](vibecoding/flutter/docs/SETUP.md)
- [Korean Setup Guide](vibecoding/flutter/docs/SETUP.ko.md)
- [Project README](vibecoding/flutter/README.md)

**Platform:** macOS only (WSL2 support untested)


## 🚀 Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/aiiiiiiiden/tools.git
   cd tools
   ```

2. **Navigate to the tool you want to use:**
   ```bash
   cd vibecoding/flutter # setup flutter vibecoding environment
   ```

3. **Follow the tool-specific instructions** in the respective README files.

## 📁 Repository Structure

```
tools/
├── README.md                           # This file
├── vibecoding/                         # Vibe coding tools
│   └── flutter/                        # Flutter environment setup
│       ├── install.sh                  # Installation script
│       ├── doctor.sh                   # Verification script
│       ├── README.md                   # Project documentation
│       └── docs/                       # Detailed guides
│           ├── SETUP.md                # English setup guide
│           ├── SETUP.ko.md             # Korean setup guide
│           └── HELLOWORLD.ko.md        # Flutter tutorial
```

## 🛠 Tool Categories

### Development Environment Setup
- **Flutter (Vibe Coding)** - Complete Flutter development environment with FVM, MCP servers, and AI tools

### Coming Soon
More tools and utilities will be added to this collection as they are developed.


## 📚 Documentation

Each tool includes its own documentation:
- `docs/` - Detailed setup and usage guides

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

**How to contribute:**
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📬 Contact

- GitHub: [aiiiiiiiden/tools](https://github.com/aiiiiiiiden/tools)
- Email: aiiiiiiiden@gmail.com
- Issues: [Report an issue](https://github.com/aiiiiiiiden/tools/issues)

## 📄 License

This project is provided as-is for development environment setup and automation.

## 🌟 Acknowledgments

Built with automation in mind to simplify developer workflows and reduce manual configuration overhead.