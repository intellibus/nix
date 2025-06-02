# System configuration module
{ lib, config, pkgs, ... }:

let
  cfg = config.system-config;
in
{
  options.system-config = {
    enable = lib.mkEnableOption "enable system configuration module";

    hostname = lib.mkOption {
      default = "nixos";
      description = "System hostname";
      type = lib.types.str;
    };

    timezone = lib.mkOption {
      default = "America/New_York";
      description = "System timezone";
      type = lib.types.str;
    };

    locale = lib.mkOption {
      default = "en_US.UTF-8";
      description = "System locale";
      type = lib.types.str;
    };

    nvidia = {
      enable = lib.mkEnableOption "NVIDIA graphics support";

      package = lib.mkOption {
        default = "stable";
        description = "NVIDIA driver package to use (stable, beta, legacy_470, legacy_390)";
        type = lib.types.enum [ "stable" "beta" "legacy_470" "legacy_390" ];
      };

      opengl = lib.mkEnableOption "Enable OpenGL support" // { default = true; };

      prime = {
        enable = lib.mkEnableOption "NVIDIA Prime support for hybrid graphics";

        nvidiaBusId = lib.mkOption {
          default = "";
          description = "NVIDIA GPU PCI bus ID (e.g., 'PCI:1:0:0')";
          type = lib.types.str;
        };

        intelBusId = lib.mkOption {
          default = "";
          description = "Intel GPU PCI bus ID (e.g., 'PCI:0:2:0')";
          type = lib.types.str;
        };

        amdgpuBusId = lib.mkOption {
          default = "";
          description = "AMD GPU PCI bus ID (e.g., 'PCI:6:0:0')";
          type = lib.types.str;
        };

        mode = lib.mkOption {
          default = "sync";
          description = "NVIDIA Prime mode (sync, offload, reverse-sync)";
          type = lib.types.enum [ "sync" "offload" "reverse-sync" ];
        };
      };

      powerManagement = {
        enable = lib.mkEnableOption "NVIDIA power management";
        finegrained = lib.mkEnableOption "Fine-grained power management (experimental)";
      };

      modesetting = lib.mkEnableOption "Enable kernel modesetting" // { default = true; };

      nvidiaPersistenced = lib.mkEnableOption "NVIDIA Persistence Daemon";
    };
  };

  config = lib.mkIf cfg.enable {
    # Hostname
    networking.hostName = cfg.hostname;

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone
    time.timeZone = cfg.timezone;

    # Select internationalisation properties
    i18n.defaultLocale = cfg.locale;
    i18n.extraLocaleSettings = {
      LC_ADDRESS = cfg.locale;
      LC_IDENTIFICATION = cfg.locale;
      LC_MEASUREMENT = cfg.locale;
      LC_MONETARY = cfg.locale;
      LC_NAME = cfg.locale;
      LC_NUMERIC = cfg.locale;
      LC_PAPER = cfg.locale;
      LC_TELEPHONE = cfg.locale;
      LC_TIME = cfg.locale;
    };

    # Enable sound with pipewire
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # NVIDIA Graphics Configuration
    services.xserver.videoDrivers = lib.mkIf cfg.nvidia.enable [ "nvidia" ];

    hardware.nvidia = lib.mkIf cfg.nvidia.enable {
      # Enable modesetting (required for wayland)
      modesetting.enable = cfg.nvidia.modesetting;

      # Enable power management (experimental)
      powerManagement.enable = cfg.nvidia.powerManagement.enable;
      powerManagement.finegrained = cfg.nvidia.powerManagement.finegrained;

      # Enable open source kernel module (experimental)
      open = false;

      # Enable nvidia settings menu
      nvidiaSettings = true;

      # Driver package selection
      package =
        if cfg.nvidia.package == "stable" then config.boot.kernelPackages.nvidiaPackages.stable
        else if cfg.nvidia.package == "beta" then config.boot.kernelPackages.nvidiaPackages.beta
        else if cfg.nvidia.package == "legacy_470" then config.boot.kernelPackages.nvidiaPackages.legacy_470
        else if cfg.nvidia.package == "legacy_390" then config.boot.kernelPackages.nvidiaPackages.legacy_390
        else config.boot.kernelPackages.nvidiaPackages.stable;

      # NVIDIA Prime configuration for hybrid graphics
      prime = lib.mkIf cfg.nvidia.prime.enable {
        # Sync mode (default) - both GPUs always on
        sync.enable = cfg.nvidia.prime.mode == "sync";

        # Offload mode - NVIDIA GPU only when needed  
        offload = lib.mkIf (cfg.nvidia.prime.mode == "offload") {
          enable = true;
          enableOffloadCmd = true;
        };

        # Reverse sync mode - NVIDIA as primary
        reverseSync.enable = cfg.nvidia.prime.mode == "reverse-sync";

        # GPU Bus IDs (find with: lspci | grep -E "VGA|3D")
        nvidiaBusId = lib.mkIf (cfg.nvidia.prime.nvidiaBusId != "") cfg.nvidia.prime.nvidiaBusId;
        intelBusId = lib.mkIf (cfg.nvidia.prime.intelBusId != "") cfg.nvidia.prime.intelBusId;
        amdgpuBusId = lib.mkIf (cfg.nvidia.prime.amdgpuBusId != "") cfg.nvidia.prime.amdgpuBusId;
      };
    };

    # Enable OpenGL support
    hardware.graphics = lib.mkIf (cfg.nvidia.enable && cfg.nvidia.opengl) {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    # NVIDIA Persistence Daemon (keeps GPU initialized)
    systemd.services.nvidia-persistenced = lib.mkIf (cfg.nvidia.enable && cfg.nvidia.nvidiaPersistenced) {
      enable = true;
    };

    # Enable flakes
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };

    # Automatic garbage collection
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };

    # System packages
    environment.systemPackages = with pkgs; [
      vim
      wget
      curl
      git
      htop
      tree
      unzip
      zip
    ];

    # Enable the OpenSSH daemon
    services.openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    # Open ports in the firewall
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    networking.firewall.enable = true;
  };
}
