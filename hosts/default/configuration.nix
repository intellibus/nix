# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Import our custom modules
    ../../modules/nixos/main-user.nix
    ../../modules/nixos/system.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/optional-services.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      # outputs.overlays.modifications
      # outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # Enable our custom modules
  main-user = {
    enable = true;
    userName = "jager";
  };

  system-config = {
    enable = true;
    hostname = "nixos";

    # NVIDIA Graphics Configuration
    nvidia = {
      enable = true; # Set to true to enable NVIDIA support
      package = "beta"; # Options: "stable", "beta", "legacy_470", "legacy_390"
      opengl = true; # Enable OpenGL support
      modesetting = true; # Enable kernel modesetting (required for Wayland)
      nvidiaPersistenced = false; # Enable persistence daemon (optional)

      # Power management (experimental features)
      powerManagement = {
        enable = false; # Enable power management
        finegrained = false; # Fine-grained power management (very experimental)
      };

      # NVIDIA Prime for hybrid graphics (laptops with Intel + NVIDIA)
      prime = {
        enable = false; # Set to true if you have hybrid graphics
        mode = "sync"; # Options: "sync", "offload", "reverse-sync"

        # Find your GPU bus IDs with: lspci | grep -E "VGA|3D"
        # Example outputs:
        # 00:02.0 VGA compatible controller: Intel Corporation Device
        # 01:00.0 3D controller: NVIDIA Corporation Device
        nvidiaBusId = ""; # Example: "PCI:1:0:0"  
        intelBusId = ""; # Example: "PCI:0:2:0"
        amdgpuBusId = ""; # Example: "PCI:6:0:0" (for AMD + NVIDIA)
      };
    };
  };

  desktop-environment = {
    enable = true;
    desktop = "gnome"; # Options: "gnome", "kde", "xfce", "none"
  };

  # Optional services (enable as needed)
  optional-services = {
    docker.enable = false; # Enable Docker
    virtualization.enable = false; # Enable KVM/QEMU
    printing.enable = true; # Enable printing
    bluetooth.enable = true; # Enable Bluetooth
    steam.enable = false; # Enable Steam gaming
    flatpak.enable = false; # Enable Flatpak
    zsh.enable = true; # Enable Zsh system-wide
  };

  # This will be set to the release version of NixOS you're using
  system.stateVersion = "24.05";
}
