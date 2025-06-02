# 🎮 NVIDIA Graphics Configuration Guide

This guide helps you configure NVIDIA graphics support in your NixOS configuration.

## 🚀 Quick Setup

### 1. Basic NVIDIA Setup

Edit `hosts/default/configuration.nix` and set:

```nix
system-config = {
  enable = true;
  hostname = "nixos";
  
  nvidia = {
    enable = true;              # Enable NVIDIA support
    package = "stable";         # Use stable drivers
    opengl = true;             # Enable OpenGL
    modesetting = true;        # Required for Wayland
  };
};
```

### 2. Find Your GPU

Check your graphics hardware:
```bash
# List all graphics devices
lspci | grep -E "VGA|3D"

# Check NVIDIA GPU specifically  
lspci | grep -i nvidia

# Check current driver (after installation)
nvidia-smi
```

## 🔧 Configuration Options

### Driver Packages

```nix
nvidia = {
  package = "stable";    # Most stable, recommended
  # package = "beta";    # Latest features, less stable
  # package = "legacy_470"; # For older GPUs (GeForce 600/700 series)
  # package = "legacy_390"; # For very old GPUs (GeForce 400/500 series)
};
```

### Power Management

```nix
nvidia = {
  powerManagement = {
    enable = true;        # Basic power management
    finegrained = false;  # Fine-grained PM (experimental, may cause issues)
  };
  nvidiaPersistenced = true; # Keep GPU initialized (servers/headless)
};
```

## 💻 Laptop/Hybrid Graphics (NVIDIA Prime)

### Intel + NVIDIA (Most Common)

1. **Find your GPU bus IDs**:
   ```bash
   lspci | grep -E "VGA|3D"
   # Example output:
   # 00:02.0 VGA compatible controller: Intel Corporation ...
   # 01:00.0 3D controller: NVIDIA Corporation ...
   ```

2. **Configure Prime**:
   ```nix
   nvidia = {
     enable = true;
     prime = {
       enable = true;
       mode = "offload";           # Battery-friendly mode
       intelBusId = "PCI:0:2:0";   # Intel GPU bus ID
       nvidiaBusId = "PCI:1:0:0";  # NVIDIA GPU bus ID
     };
   };
   ```

### Prime Modes

```nix
prime = {
  mode = "sync";        # Both GPUs always on (performance)
  # mode = "offload";   # NVIDIA only when needed (battery life)
  # mode = "reverse-sync"; # NVIDIA as primary display
};
```

### Using Offload Mode

With offload mode, run applications on NVIDIA GPU:
```bash
# Run application with NVIDIA GPU
nvidia-offload glxinfo | grep "OpenGL renderer"
nvidia-offload steam
nvidia-offload blender

# The nvidia-offload command is automatically available
```

### AMD + NVIDIA

```nix
nvidia = {
  prime = {
    enable = true;
    mode = "sync";
    amdgpuBusId = "PCI:6:0:0";   # AMD GPU bus ID  
    nvidiaBusId = "PCI:1:0:0";   # NVIDIA GPU bus ID
  };
};
```

## 🎯 Common Configurations

### Gaming Desktop
```nix
nvidia = {
  enable = true;
  package = "stable";
  opengl = true;
  modesetting = true;
  nvidiaPersistenced = true;
  powerManagement.enable = false; # Desktop doesn't need PM
};
```

### Gaming Laptop
```nix
nvidia = {
  enable = true;
  package = "stable";
  opengl = true;
  modesetting = true;
  prime = {
    enable = true;
    mode = "offload";              # Battery friendly
    intelBusId = "PCI:0:2:0";     # Replace with your IDs
    nvidiaBusId = "PCI:1:0:0";
  };
  powerManagement.enable = true;
};
```

### Workstation/Server
```nix
nvidia = {
  enable = true;
  package = "stable";
  opengl = true;
  modesetting = true;
  nvidiaPersistenced = true;       # Keep GPU ready
  powerManagement.enable = false;
};
```

## 🛠️ Troubleshooting

### Common Issues

1. **Black screen after boot**
   - Disable modesetting: `modesetting = false;`
   - Try legacy drivers if you have an older GPU

2. **Wayland not working**
   - Ensure `modesetting = true;`
   - Check if your desktop environment supports NVIDIA + Wayland

3. **Prime not working**
   - Verify bus IDs with `lspci`
   - Check `/var/log/Xorg.0.log` for errors
   - Try different Prime modes

4. **Performance issues**
   - Enable persistence daemon: `nvidiaPersistenced = true;`
   - Check power management settings
   - Verify you're using the NVIDIA GPU: `nvidia-smi`

### Diagnostic Commands

```bash
# Check NVIDIA driver version
nvidia-smi

# Check OpenGL renderer
glxinfo | grep "OpenGL renderer"

# Check Vulkan support  
vulkaninfo | head

# Monitor GPU usage
watch -n 1 nvidia-smi

# Check Prime status (laptops)
cat /proc/driver/nvidia/gpus/*/information

# Check kernel modules
lsmod | grep nvidia
```

### Getting Help

1. **Check logs**:
   ```bash
   journalctl -b | grep -i nvidia
   journalctl -b | grep -i prime
   ```

2. **Hardware information**:
   ```bash
   # Full hardware info
   nix-shell -p pciutils --run "lspci -v | grep -A 20 -i nvidia"
   
   # Kernel modules
   nix-shell -p kmod --run "lsmod | grep nvidia"
   ```

3. **NixOS-specific resources**:
   - [NixOS Wiki - NVIDIA](https://nixos.wiki/wiki/Nvidia)
   - [NixOS Manual - Hardware](https://nixos.org/manual/nixos/stable/index.html#sec-gpu-accel)

## 🎮 Gaming Additions

For gaming, you might also want to enable these optional services:

```nix
optional-services = {
  steam.enable = true;           # Steam gaming platform
  docker.enable = true;          # For containerized applications
};
```

And consider adding gaming packages to your user environment in `modules/home-manager/packages.nix`:

```nix
# Gaming packages
lutris          # Game launcher
wine            # Windows compatibility
gamemode        # Performance optimization
mangohud        # Performance overlay
```

## 📋 Deployment Checklist

After configuring NVIDIA:

1. ✅ **Configure settings** in `hosts/default/configuration.nix`
2. ✅ **Find GPU bus IDs** (if using Prime): `lspci | grep -E "VGA|3D"`
3. ✅ **Update configuration**: `sudo nixos-rebuild switch --flake .#nixos`
4. ✅ **Reboot system** to load new drivers
5. ✅ **Test functionality**: `nvidia-smi` and `glxinfo | grep NVIDIA`
6. ✅ **Verify Prime** (if applicable): Test offload commands

Remember to reboot after enabling NVIDIA support for the first time!
