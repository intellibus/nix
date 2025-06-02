# 🤖 CI/CD Documentation

This document describes the CI/CD pipeline for the NixOS configuration repository.

## 🏗️ GitHub Actions Workflows

### 1. 🔍 CI Workflow (`ci.yml`)
**Triggers**: Push to main/master, Pull Requests, Manual dispatch

**Jobs**:
- **🧪 Check Flake**: Validates flake syntax and structure
- **🏗️ Build Configurations**: Builds NixOS system configurations
- **🏠 Check Home Manager**: Validates Home Manager configurations
- **📝 Format Check**: Ensures code is properly formatted
- **🔒 Security Check**: Scans for secrets and hardcoded passwords

### 2. 🔄 Auto Update Workflow (`update.yml`)
**Triggers**: Weekly schedule (Sundays 2 AM UTC), Manual dispatch

**Jobs**:
- **🔄 Update Flake Inputs**: Updates dependencies and creates PR
- **🆕 Check NixOS Releases**: Notifies about new NixOS versions

### 3. 📦 Release Workflow (`release.yml`)
**Triggers**: Git tags starting with 'v', Manual dispatch

**Jobs**:
- **🎉 Create Release**: Final validation, changelog generation, tarball creation

### 4. 🤖 Bot Commands Workflow (`bot.yml`)
**Triggers**: Issue comments containing `/bot`

**Available Commands**:
- `/bot format` - 📝 Auto-format Nix files
- `/bot check` - 🔍 Run flake validation
- `/bot build` - 🏗️ Build configuration
- `/bot help` - 📚 Show available commands

### 5. 📋 Issue Management (`issue-management.yml`)
**Triggers**: New issues

**Features**:
- 🏷️ Auto-labeling based on content
- 🤝 Welcome message for new contributors

## 🎣 Pre-commit Hooks

The repository includes pre-commit hooks for:
- 🧹 **Trailing whitespace removal**
- 📝 **End of file fixing**
- 🔀 **Merge conflict detection**
- 📦 **Large file checking**
- ❄️ **Nix formatting**
- 🔍 **Flake validation**
- 🔒 **Security checks**
- 📚 **Documentation validation**

### Setup Pre-commit
```bash
# Install hooks
make pre-commit-install

# Run on all files
make pre-commit-run
```

## 🧪 Testing Framework

### Local Testing
```bash
# Full test suite
./test.sh

# Quick tests only
./test.sh --quick

# Auto-fix formatting
./test.sh --format-fix

# Using Make
make test
make test-quick
```

### Test Categories
1. **📁 Directory Structure**: Validates required files exist
2. **🔍 Flake Validation**: Syntax and reference checking
3. **🏗️ Build Tests**: Ensures configurations build successfully
4. **📝 Format Checks**: Code style validation
5. **🔒 Security Scans**: Detects potential security issues
6. **📚 Documentation**: Verifies documentation completeness

## 🔧 Development Environment

### Using Nix Develop
```bash
# Enter dev shell
nix develop

# Or use direnv for automatic activation
direnv allow
```

### Development Tools Included
- ❄️ **Nix tools**: nixpkgs-fmt, nil (LSP), nix-tree
- 🔍 **Analysis**: statix (linter), deadnix (dead code)
- 🤖 **CI/CD**: pre-commit, act (local GitHub Actions)
- 📝 **Documentation**: mdbook, pandoc
- 🛠️ **Utilities**: jq, yq, tree, ripgrep

## 📊 Quality Gates

### Pull Request Requirements
- ✅ All CI checks must pass
- ✅ Code must be properly formatted
- ✅ No security issues detected
- ✅ Configuration must build successfully
- ✅ Documentation must be updated (if applicable)

### Automatic Checks
```bash
# Locally run the same checks as CI
make ci-local

# Or individual checks
make check
make format
make lint
```

## 🚀 Deployment Process

### Manual Deployment
```bash
# On target system
cd /etc/nixos
sudo nixos-rebuild switch --flake .#hostname
```

### Automated Deployment (Future Enhancement)
Consider adding:
- 🏠 **Home Lab Integration**: Automatic deployment to test systems
- 📦 **Binary Cache**: Speed up builds with cached artifacts
- 🔄 **Rollback Automation**: Automatic rollback on failure

## 📈 Monitoring and Metrics

### GitHub Insights
- 📊 **Action Usage**: Monitor CI/CD resource consumption
- 🔄 **Success Rates**: Track build success/failure rates
- ⏱️ **Build Times**: Monitor performance trends

### Custom Metrics (Future)
- 🏗️ **Build success rate per configuration**
- 📦 **Dependency update frequency**
- 🔒 **Security scan results**

## 🔒 Security Considerations

### Secrets Management
- 🚫 **Never commit secrets** to the repository
- 🔑 **Use GitHub Secrets** for sensitive CI/CD data
- 🔍 **Automated scanning** prevents accidental commits

### Access Control
- 🛡️ **Branch protection** rules on main branch
- 👥 **Review requirements** for all changes
- 🔐 **Limited repository permissions**

## 💾 Disk Space Management

### CI/CD Optimizations
The CI pipeline includes several optimizations to handle GitHub Actions' limited disk space (~14GB):

#### **Automatic Cleanup**
- Removes unnecessary system packages before builds
- Clears Docker cache and large tool directories
- Runs `nix-collect-garbage` after each build step

#### **Conditional Package Inclusion**
Large packages like TeXLive are automatically excluded during CI builds:
```nix
# In modules/home-manager/packages.nix
] ++ lib.optionals (builtins.getEnv "NIXOS_CI_BUILD" != "true") [
  texlive.combined.scheme-medium  # ~2GB LaTeX distribution
];
```

#### **Build Optimizations**
- Limited parallel jobs (`max-jobs 1`, `cores 2`)
- Nix store size limits (`min-free`/`max-free`)
- Continuous disk space monitoring

#### **Local Testing**
To test with the same CI environment locally:
```bash
export NIXOS_CI_BUILD=true
nix build .#homeConfigurations."jager@nixos".activationPackage
```

## 🆘 Troubleshooting CI/CD

### Common Issues

**❌ Flake check fails**
```bash
# Run locally to debug
nix flake check --show-trace
```

**❌ Build failures**
```bash
# Verbose build output
nix build --show-trace -v
```

**❌ Format check fails**
```bash
# Auto-fix formatting
nixpkgs-fmt .
```

**❌ Pre-commit issues**
```bash
# Reinstall hooks
pre-commit uninstall
pre-commit install
```

### Debug Commands
```bash
# Check CI status locally
act -j check-flake --dryrun

# Validate GitHub Actions syntax
act --list

# Test pre-commit hooks
pre-commit run --all-files --verbose
```

## 📚 Resources

- 📖 [GitHub Actions Documentation](https://docs.github.com/en/actions)
- 🎣 [Pre-commit Documentation](https://pre-commit.com/)
- ❄️ [Nix Flakes Reference](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html)
- 🏗️ [NixOS Configuration Guide](https://nixos.org/manual/nixos/stable/)

---

🎉 **Happy CI/CD-ing!** Remember: automate everything, test early, test often! 🚀
