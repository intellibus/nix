---
name: 🐛 Bug Report
about: Create a report to help us improve the configuration
title: '🐛 [BUG] '
labels: ['🐛 bug']
assignees: ''
---

## 🐛 Bug Description
A clear and concise description of what the bug is.

## 🔄 Steps to Reproduce
Steps to reproduce the behavior:
1. Go to '...'
2. Run command '....'
3. See error

## ✅ Expected Behavior
A clear and concise description of what you expected to happen.

## 💥 Actual Behavior
A clear and concise description of what actually happened.

## 📋 Environment Information
- **NixOS Version**: [e.g. 24.05]
- **Hardware**: [e.g. x86_64, aarch64]
- **Desktop Environment**: [e.g. GNOME, KDE, XFCE, none]
- **Configuration Branch/Commit**: [e.g. main, abc1234]

## 📄 Configuration Details
```nix
# Paste relevant configuration snippets here
```

## 📝 Error Logs
```
# Paste error messages or logs here
# You can get these with: journalctl -xe
# Or from: sudo nixos-rebuild switch --show-trace
```

## 🔍 Additional Context
Add any other context about the problem here.

## ✔️ Checklist
- [ ] I have read the [README.md](../README.md)
- [ ] I have checked the [docs/](../docs/) directory for solutions
- [ ] I have searched existing issues for duplicates
- [ ] I have tried `nix flake check` to validate the configuration
- [ ] I have tried rebuilding with `--show-trace` for detailed errors
