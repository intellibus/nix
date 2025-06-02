# 🎯 NixOS Configuration Repository

## 📚 About
A modern, modular NixOS configuration with Home Manager integration. Perfect for beginners and advanced users alike! ❄️

## ✨ Features
- 🏗️ **Modular Design** - Easy to customize and maintain
- 🖥️ **Multiple Desktop Environments** - GNOME, KDE, XFCE support
- 🏠 **Home Manager Integration** - Complete user environment management
- 🔧 **Optional Services** - Docker, virtualization, printing, and more
- 🤖 **Automated Setup** - Interactive configuration script
- 📝 **Rich Documentation** - Comprehensive guides and quick reference
- 🔄 **CI/CD Pipeline** - Automated testing and validation

## 🚀 Quick Start

### 1️⃣ Clone Repository
```bash
git clone https://github.com/YOUR_USERNAME/nixos-config.git
cd nixos-config
```

### 2️⃣ Run Setup
```bash
./setup.sh
```

### 3️⃣ Apply Configuration
```bash
sudo nixos-rebuild switch --flake .#your-hostname
```

## 📖 Documentation
- 📋 [Complete Setup Guide](README.md)
- 🎮 [NVIDIA Configuration](docs/NVIDIA.md)
- 🔧 [Customization Examples](docs/examples/)

## 🤝 Contributing
We welcome contributions! Please read our [Contributing Guidelines](CONTRIBUTING.md) and check out our [Code of Conduct](CODE_OF_CONDUCT.md).

### 🐛 Found a Bug?
[Create a bug report](../../issues/new?template=bug_report.md)

### ✨ Have an Idea?
[Submit a feature request](../../issues/new?template=feature_request.md)

### ❓ Need Help?
[Ask a question](../../issues/new?template=question.md)

## 🏷️ Labels
- 🐛 `bug` - Something isn't working
- ✨ `enhancement` - New feature or request
- 📚 `documentation` - Improvements or additions to docs
- ❓ `question` - Further information is requested
- 🔄 `auto-update` - Automated dependency updates
- 📦 `dependencies` - Pull requests that update dependencies

## 🤖 Bot Commands
Use these commands in PR comments:
- `/bot check` - 🔍 Run flake validation
- `/bot format` - 📝 Auto-format code
- `/bot build` - 🏗️ Build configuration
- `/bot help` - 📚 Show available commands

## 📊 Project Stats
![GitHub issues](https://img.shields.io/github/issues/YOUR_USERNAME/nixos-config?style=flat-square)
![GitHub pull requests](https://img.shields.io/github/issues-pr/YOUR_USERNAME/nixos-config?style=flat-square)
![GitHub stars](https://img.shields.io/github/stars/YOUR_USERNAME/nixos-config?style=flat-square)
![GitHub license](https://img.shields.io/github/license/YOUR_USERNAME/nixos-config?style=flat-square)

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
Made with ❤️ and ❄️ by the NixOS community
