# NixOS Configuration

[![CI/CD Status](https://github.com/j4v3l/Nixos/workflows/🔍%20NixOS%20Configuration%20CI/badge.svg)](https://github.com/j4v3l/Nixos/actions/workflows/ci.yml)
[![Auto Update](https://github.com/j4v3l/Nixos/workflows/🔄%20Auto%20Update%20Dependencies/badge.svg)](https://github.com/j4v3l/Nixos/actions/workflows/update.yml)
[![NixOS](https://img.shields.io/badge/NixOS-24.05-blue.svg?style=flat&logo=NixOS&logoColor=white)](https://nixos.org)
[![Flakes](https://img.shields.io/badge/Nix-Flakes-blue.svg?style=flat&logo=nixos&logoColor=white)](https://nixos.wiki/wiki/Flakes)

> 🌟 **Modern, modular NixOS configuration with automated CI/CD and intelligent bot assistance**

## ✨ Features

- 🏗️ **Modular Architecture** - Clean system/user separation
- 🤖 **Automated CI/CD** - Testing, formatting, security checks
- 🔄 **Auto-Updates** - Weekly dependency updates via PRs
- 🛡️ **Security First** - Secret scanning & vulnerability checks
- 📦 **Bot Commands** - Interactive PR management (`/bot help`)
- 🎯 **Multi-Desktop** - GNOME, KDE, XFCE, Hyprland support

## 🚦 Status

| Component | Status |
|-----------|--------|
| 🧪 Flake Check | ![Passing](https://img.shields.io/badge/status-passing-brightgreen) |
| 🏗️ Build Test | ![Passing](https://img.shields.io/badge/status-passing-brightgreen) |
| 🔒 Security | ![Passing](https://img.shields.io/badge/status-passing-brightgreen) |
| 🔄 Dependencies | ![Up to date](https://img.shields.io/badge/status-up%20to%20date-brightgreen) |

## 🤖 Bot Commands

| Command | Action |
|---------|--------|
| `/bot format` | Auto-format Nix files |
| `/bot check` | Run flake validation |
| `/bot build` | Test configuration build |

## 📁 Structure

```text
├── flake.nix                    # Main flake configuration
├── hosts/default/               # Host-specific configs
└── modules/
    ├── nixos/                   # System modules
    └── home-manager/            # User modules
```

## 🚀 Quick Start

1. **Setup hardware config**:

   ```bash
   sudo nixos-generate-config
   sudo cp /etc/nixos/hardware-configuration.nix hosts/default/
   ```

2. **Update personal info** in `flake.nix` and `modules/home-manager/git.nix`

3. **Deploy**:

   ```bash
   sudo nixos-rebuild switch --flake .#nixos
   ```

## 🛠️ Common Commands

```bash
# System rebuild
sudo nixos-rebuild switch --flake .#nixos

# Update dependencies
nix flake update

# Validate configuration
nix flake check

# Development environment
nix develop

# Run tests
./test.sh

# Cleanup
sudo nix-collect-garbage -d
```

## 🔧 Customization

- **System packages**: Edit `modules/nixos/system.nix`
- **User packages**: Edit `modules/home-manager/packages.nix`
- **Desktop environment**: Change `desktop` option in `configuration.nix`
  - Available options: `"gnome"`, `"kde"`, `"xfce"`, `"hyprland"`, `"none"`
  - For Hyprland: Also set `hyprland-config.enable = true` in `home.nix`
  - See `docs/HYPRLAND.md` for complete Hyprland setup guide

## 🐛 Troubleshooting

**Build fails**: Run `nix flake check --show-trace`  
**CI issues**: Test locally with `./test-ci.sh` or `act -j check-flake`  
**Rollback**: `sudo nixos-rebuild switch --rollback`  
**Disk space in CI**: Large packages (TeXLive) auto-excluded via `NIXOS_CI_BUILD=true`  
**Kernel module errors**: CI environment automatically excludes hardware-dependent packages

### Common Issues

**Package Collision**: If you get "collision between packages", check for duplicates:

- Don't install packages via both `packages.nix` and `programs.*` configuration
- Example: Remove `neovim` from packages if using `programs.neovim.enable = true`

**Hardware Config**: Update `hosts/default/hardware-configuration.nix` with real values:

```bash
sudo nixos-generate-config --root /mnt
# Copy generated hardware-configuration.nix to hosts/default/
```

**Path not in Nix store**: Usually caused by placeholder UUIDs in hardware config

## 📚 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Package Search](https://search.nixos.org/packages)
- [Options Search](https://search.nixos.org/options)
- [CI/CD Docs](docs/CICD.md)

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](.github/CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md) before submitting pull requests.

Happy NixOS-ing! 🎉
