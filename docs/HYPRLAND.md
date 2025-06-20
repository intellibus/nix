# Hyprland Configuration Guide

This document provides comprehensive information about the Hyprland (Wayland compositor) support in this NixOS configuration.

## Overview

Hyprland is a highly customizable dynamic tiling Wayland compositor that doesn't sacrifice on its looks. This configuration provides a complete Hyprland setup with:

- **Window Management**: Dynamic tiling with customizable layouts
- **Status Bar**: Waybar with system information and workspaces
- **Notifications**: Mako notification daemon
- **Screen Locking**: Hyprlock with blur effects
- **Idle Management**: Hypridle for automatic screen locking
- **Application Launcher**: Rofi for Wayland (rofi-wayland)
- **File Manager**: Nautilus with proper Wayland support
- **Terminal**: Kitty with transparency and theming
- **Screenshots**: Grim and Slurp for Wayland screenshots

## Quick Setup

1. **Enable Hyprland in your configuration:**

   ```nix
   # In hosts/default/configuration.nix
   desktop = "hyprland";
   ```

2. **Enable Home Manager Hyprland module:**

   ```nix
   # In hosts/default/home.nix
   hyprland.enable = true;
   ```

3. **Rebuild your system:**

   ```bash
   sudo nixos-rebuild switch --flake .
   ```

4. **Log out and select Hyprland from your display manager**

## Configuration Structure

### NixOS Module (`modules/nixos/desktop.nix`)

When `desktop = "hyprland"` is set, the following components are enabled:

- **Hyprland**: The compositor itself
- **XDG Desktop Portal**: For proper application integration
- **Graphics Support**: Mesa drivers and hardware acceleration
- **Audio**: PulseAudio integration
- **Input Methods**: Support for various input devices

### Home Manager Module (`modules/home-manager/hyprland.nix`)

The Home Manager module provides:

- **Hyprland Configuration**: Keybindings, layouts, and appearance
- **Waybar**: Customized status bar with workspaces and system info
- **Mako**: Notification daemon with styling
- **Hyprlock**: Screen locker with blur effects
- **Hypridle**: Idle management and auto-lock
- **Environment Variables**: Proper Wayland environment setup

## Default Keybindings

### Window Management

- `SUPER + Q`: Close active window
- `SUPER + M`: Exit Hyprland
- `SUPER + V`: Toggle floating mode
- `SUPER + P`: Toggle pseudo-tiling
- `SUPER + J`: Toggle split direction

### Navigation

- `SUPER + Arrow Keys`: Move focus between windows
- `SUPER + 1-0`: Switch to workspace 1-10
- `SUPER + SHIFT + 1-0`: Move window to workspace 1-10

### Applications

- `SUPER + Return`: Open terminal (Kitty)
- `SUPER + D`: Open application launcher (Rofi)
- `SUPER + E`: Open file manager (Nautilus)

### System

- `SUPER + L`: Lock screen
- `SUPER + SHIFT + S`: Take screenshot

### Layout

- `SUPER + SHIFT + Arrow Keys`: Move windows
- `SUPER + CTRL + Arrow Keys`: Resize windows
- `SUPER + Mouse`: Move/resize windows

## Customization

### Theming

The configuration uses a Nord-inspired color scheme with:
- **Primary**: `#5e81ac` (Nord blue)
- **Background**: `#2e3440` (Nord dark)
- **Foreground**: `#d8dee9` (Nord light)
- **Accent**: `#88c0d0` (Nord cyan)

### Waybar Configuration

Waybar is configured with modules for:
- Workspaces with workspace-specific icons
- System tray with application indicators
- Clock with date and time
- CPU and memory usage
- Network status
- Audio volume control
- Battery status (on laptops)

### Window Rules

Predefined rules for common applications:
- **Floating Windows**: Calculators, dialogs, picture-in-picture
- **Workspace Assignment**: Browsers to workspace 2, media to workspace 8
- **Opacity Rules**: Terminal transparency, inactive window dimming

## Environment Variables

The configuration sets appropriate environment variables for Wayland:

```bash
NIXOS_OZONE_WL=1              # Enable Wayland for Chromium/Electron apps
XDG_CURRENT_DESKTOP=Hyprland  # Desktop environment identification
XDG_SESSION_TYPE=wayland      # Session type for applications
WLR_NO_HARDWARE_CURSORS=1     # Cursor compatibility (if needed)
```

## Troubleshooting

### Common Issues

#### Applications Not Starting
Some applications may need Wayland-specific flags:
```bash
# For Chromium-based applications
google-chrome --enable-features=UseOzonePlatform --ozone-platform=wayland

# For Firefox (should work automatically with NIXOS_OZONE_WL=1)
firefox
```

#### Screen Sharing
For screen sharing in applications like Discord or Zoom:
1. Ensure `xdg-desktop-portal-hyprland` is installed (included in configuration)
2. Applications should prompt for screen selection
3. Some applications may require additional Wayland flags

#### Performance Issues
If you experience performance issues:
1. Check if hardware acceleration is working:
   ```bash
   glxinfo | grep "OpenGL renderer"
   ```
2. Ensure proper graphics drivers are installed
3. Consider disabling animations for lower-end hardware

#### Cursor Issues
If cursors are invisible or corrupted:
1. The configuration includes `WLR_NO_HARDWARE_CURSORS=1`
2. Try different cursor themes in `hyprland.nix`
3. Ensure cursor size is appropriate for your display

### Application Compatibility

#### Native Wayland Support
Applications with excellent Wayland support:
- Firefox
- Chromium/Chrome (with flags)
- GNOME applications
- Most modern Qt applications
- Electron apps (with `NIXOS_OZONE_WL=1`)

#### XWayland Fallback
Applications that run through XWayland:
- Most X11-only applications
- Some older Qt applications
- Legacy software

### Performance Optimization

#### For Gaming
```nix
# Add to hyprland configuration
misc {
    vfr = true
    vrr = 1
}

# Disable compositor for fullscreen games
windowrulev2 = immediate, class:^(steam_app_).*
```

#### For Productivity
```nix
# Reduce animations for snappier feel
animations {
    bezier = linear, 0.0, 0.0, 1.0, 1.0
    animation = windows, 1, 3, linear
    animation = windowsOut, 1, 3, linear
    animation = border, 1, 5, linear
    animation = fade, 1, 5, linear
    animation = workspaces, 1, 3, linear
}
```

## Additional Configuration

### Adding Custom Keybindings

Edit `modules/home-manager/hyprland.nix`:

```nix
bind = [
    # Your custom keybindings
    "$mod, F1, exec, your-application"
    "$mod SHIFT, F1, exec, your-other-application"
];
```

### Workspace-Specific Rules

```nix
windowrulev2 = [
    "workspace 3, class:^(discord)$"
    "workspace 4, class:^(steam)$"
    "float, class:^(your-floating-app)$"
];
```

### Monitor Configuration

For multiple monitors, add to the Hyprland configuration:

```nix
monitor = [
    "DP-1,1920x1080@60,0x0,1"
    "HDMI-A-1,1920x1080@60,1920x0,1"
];
```

## Advanced Features

### Plugins

Hyprland supports plugins for additional functionality:
- **hyprfocus**: Enhanced window focus effects
- **hyprbars**: Custom title bars
- **hyprwinwrap**: Wallpaper integration

### Scripting

The configuration includes example scripts for:
- Screenshot management with Grim and Slurp
- Workspace switching with animations
- Window management automation

### Integration with Other Tools

#### With Neovim/Vim
Configure your editor for Wayland clipboard:
```bash
# Wayland clipboard support
alias vim='wl-copy --clear && nvim'
```

#### With tmux
Ensure tmux works well with Wayland terminals:
```bash
# In your tmux config
set -s copy-command 'wl-copy'
```

## Resources

- [Official Hyprland Documentation](https://hyprland.org/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Waybar Documentation](https://github.com/Alexays/Waybar/wiki)
- [Mako Documentation](https://github.com/emersion/mako)

## Contributing

To contribute improvements to the Hyprland configuration:

1. Make changes in the `feature/hyprland-enhancement` branch
2. Test thoroughly with `nix flake check`
3. Update this documentation if needed
4. Submit a pull request with clear descriptions

## Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review Hyprland logs: `journalctl -u display-manager`
3. Check the official Hyprland documentation
4. File an issue with reproduction steps
