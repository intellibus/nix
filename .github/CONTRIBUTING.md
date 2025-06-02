# 🤝 Contributing to NixOS Configuration

Thank you for your interest in contributing! 🎉 This document provides guidelines for contributing to this NixOS configuration project.

## 🏗️ Development Setup

### 📋 Prerequisites
- NixOS system or Nix package manager installed
- Git configured with your name and email
- Basic understanding of Nix language and NixOS

### 🔧 Setting Up Development Environment
```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/nixos-config.git
cd nixos-config

# Check the configuration
nix flake check

# Test build (without applying)
nix build .#nixosConfigurations.nixos.config.system.build.toplevel
```

## 📝 Code Style

### 🎨 Formatting
- Use `nixpkgs-fmt` for formatting: `nix run nixpkgs#nixpkgs-fmt -- .`
- Keep lines under 100 characters when possible
- Use 2 spaces for indentation
- Add trailing commas in lists and attribute sets

### 📂 File Organization
- **System modules**: `modules/nixos/`
- **User modules**: `modules/home-manager/`
- **Host configs**: `hosts/`
- **Documentation**: Root directory and `docs/`

### 💬 Comments
- Add comments for complex configurations
- Explain why something is configured in a particular way
- Include links to relevant documentation

## 🔄 Contribution Process

### 1️⃣ Fork and Clone
```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/nixos-config.git
```

### 2️⃣ Create a Branch
```bash
git checkout -b feature/amazing-new-feature
# or
git checkout -b fix/important-bug-fix
```

### 3️⃣ Make Changes
- Follow the code style guidelines
- Test your changes thoroughly
- Update documentation if needed

### 4️⃣ Test Your Changes
```bash
# Check flake syntax
nix flake check

# Build configuration
nix build .#nixosConfigurations.nixos.config.system.build.toplevel

# Format code
nix run nixpkgs#nixpkgs-fmt -- .

# Test on actual system (if possible)
sudo nixos-rebuild test --flake .#your-hostname
```

### 5️⃣ Commit Changes
```bash
git add .
git commit -m "✨ feat: add amazing new feature

- Implemented feature X
- Updated documentation
- Added tests"
```

### 📝 Commit Message Convention
Use [Conventional Commits](https://www.conventionalcommits.org/) with emojis:

- `✨ feat:` - New features
- `🐛 fix:` - Bug fixes
- `📚 docs:` - Documentation changes
- `🎨 style:` - Code style changes
- `♻️ refactor:` - Code refactoring
- `🧪 test:` - Adding tests
- `🔧 chore:` - Maintenance tasks

### 6️⃣ Push and Create PR
```bash
git push origin feature/amazing-new-feature
```

Then create a Pull Request on GitHub using our template.

## 🔍 Review Process

### 🎯 What We Look For
- ✅ Code follows style guidelines
- ✅ Changes are well-tested
- ✅ Documentation is updated
- ✅ CI checks pass
- ✅ Commit messages are clear
- ✅ No breaking changes without justification

### 🤖 Automated Checks
- **Flake Check**: Validates Nix syntax and references
- **Build Test**: Ensures configuration builds successfully
- **Format Check**: Verifies code formatting
- **Security Check**: Scans for potential security issues

### 👥 Review Timeline
- Small changes: Usually reviewed within 1-2 days
- Large changes: May take up to a week
- We aim to provide constructive feedback quickly

## 📋 Types of Contributions

### 🐛 Bug Fixes
- Fix configuration errors
- Resolve compatibility issues
- Improve error handling

### ✨ New Features
- Add new modules
- Implement optional services
- Enhance existing functionality

### 📚 Documentation
- Improve setup instructions
- Add usage examples
- Fix typos and unclear explanations

### 🔧 Infrastructure
- Improve CI/CD workflows
- Enhance automation
- Add useful scripts

## ❓ Getting Help

### 💬 Communication Channels
- 🐛 **Bug Reports**: Use GitHub Issues
- ✨ **Feature Requests**: Use GitHub Issues
- ❓ **Questions**: Use GitHub Discussions or Issues
- 💡 **Ideas**: Start a GitHub Discussion

### 📚 Learning Resources
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Language Tutorial](https://nixos.org/guides/nix-language.html)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nixpkgs Manual](https://nixos.org/manual/nixpkgs/stable/)

## 🏷️ Issue Labels

When creating issues, we'll apply appropriate labels:

- 🐛 `bug` - Something isn't working
- ✨ `enhancement` - New feature or request
- 📚 `documentation` - Improvements to docs
- ❓ `question` - Further information needed
- 🔄 `auto-update` - Automated updates
- 🚀 `priority-high` - Important issues
- 🆘 `help-wanted` - Looking for contributors
- 🥇 `good-first-issue` - Good for newcomers

## 🎖️ Recognition

Contributors will be:
- Listed in the project README
- Credited in release notes
- Given GitHub repository permissions (for regular contributors)

## 📄 License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

Thank you for contributing to make NixOS more accessible! 🙏 ❄️
