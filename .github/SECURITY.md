# 🔒 Security Policy

## 🛡️ Supported Versions

We provide security updates for the following versions:

| Version | Supported          | NixOS Version |
| ------- | ------------------ | ------------- |
| main    | ✅ Yes             | 24.05+        |
| v2.x.x  | ✅ Yes             | 24.05         |
| v1.x.x  | ❌ No              | 23.11         |

## 🚨 Reporting a Vulnerability

If you discover a security vulnerability, please follow these steps:

### 1️⃣ **DO NOT** create a public issue
Security vulnerabilities should not be disclosed publicly until they are resolved.

### 2️⃣ Report privately
Please use GitHub's private vulnerability reporting feature:

Or use GitHub's private vulnerability reporting:
1. Go to the **Security** tab
2. Click **Report a vulnerability**
3. Fill out the form with details

### 3️⃣ Include these details
- 📋 Description of the vulnerability
- 🔄 Steps to reproduce
- 🎯 Potential impact
- 💡 Suggested fix (if you have one)
- 🖥️ Affected versions/configurations

## 🔍 Security Considerations

### 🔐 Configuration Security
This repository contains:
- ✅ **Safe**: Configuration templates and examples
- ⚠️ **Caution**: Some services may expose network ports
- ❌ **Avoid**: Never commit passwords or private keys

### 🛡️ Best Practices Implemented
- 🔒 No hardcoded passwords (uses `initialPassword` for first setup)
- 🚫 SSH root login disabled by default
- 🔥 Firewall enabled by default
- 🔑 Password authentication disabled for SSH
- 🧹 Regular dependency updates via automation

### ⚠️ Security Notes
- 🔄 Change default passwords after first login
- 🔑 Set up SSH keys properly
- 🔒 Review and customize firewall rules
- 📦 Keep system updated with `nix flake update`
- 🔍 Audit optional services before enabling

## 🚀 Response Timeline

- **Initial Response**: Within 24 hours
- **Assessment**: Within 72 hours
- **Fix Development**: Varies by complexity
- **Public Disclosure**: After fix is available

## 🏆 Security Credits

We appreciate security researchers who help make this project safer:
- 🙏 Contributors will be credited (unless they prefer anonymity)
- 📢 Public acknowledgment in release notes
- 🎖️ Hall of Fame section (if applicable)

## 📚 Security Resources

### 🔗 Related Documentation
- [NixOS Security](https://nixos.org/manual/nixos/stable/index.html#sec-security)
- [Nix Security Model](https://nixos.org/guides/nix-security.html)
- [Home Manager Security](https://nix-community.github.io/home-manager/)

### 🛠️ Security Tools
Built into CI/CD:
- 🔍 **TruffleHog** - Secret scanning
- 🔒 **Custom checks** - Password detection
- 🔄 **Automated updates** - Dependency freshness

---

🔒 **Remember**: Security is everyone's responsibility. When in doubt, ask! 🤝
