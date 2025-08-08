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
      type = lib.types.str;
      description = "System hostname";
    };

    timezone = lib.mkOption {
      default = "America/New_York";
      type = lib.types.str;
      description = "System timezone";
    };

    locale = lib.mkOption {
      default = "en_US.UTF-8";
      type = lib.types.str;
      description = "System locale";
    };

    nvidia = {
      enable = lib.mkEnableOption "NVIDIA graphics support";

      package = lib.mkOption {
        default = "stable";
        type = lib.types.enum [ "stable" "beta" "legacy_470" "legacy_390" ];
        description = "NVIDIA driver package";
      };

      prime = {
        enable = lib.mkEnableOption "Enable PRIME offloading/sync";

        mode = lib.mkOption {
          default = "sync";
          type = lib.types.enum [ "sync" "offload" "reverse-sync" ];
          description = "NVIDIA Prime mode";
        };

        nvidiaBusId = lib.mkOption { default = ""; type = lib.types.str; };
        intelBusId = lib.mkOption { default = ""; type = lib.types.str; };
        amdgpuBusId = lib.mkOption { default = ""; type = lib.types.str; };
      };

      powerManagement = {
        enable = lib.mkEnableOption "NVIDIA power management";
        finegrained = lib.mkEnableOption "Fine-grained power management";
      };

      modesetting = lib.mkEnableOption "Enable kernel modesetting" // { default = true; };

      nvidiaPersistenced = lib.mkEnableOption "NVIDIA Persistence Daemon";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.hostName = cfg.hostname;

    # Always CI-safe
    boot.loader.systemd-boot.enable = false;
    boot.loader.efi.canTouchEfiVariables = false;

    # Time/locale
    time.timeZone = cfg.timezone;
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

    # Audio off in CI
    services.pulseaudio.enable = false;
    security.rtkit.enable = false;
    services.pipewire = {
      enable = false;
      alsa.enable = false;
      alsa.support32Bit = false;
      pulse.enable = false;
    };

    # NVIDIA (defaults off in host; safe if enabled)
    services.xserver.videoDrivers = lib.mkIf cfg.nvidia.enable [ "nvidia" ];
    hardware.nvidia = lib.mkIf cfg.nvidia.enable {
      modesetting.enable = cfg.nvidia.modesetting;
      powerManagement.enable = cfg.nvidia.powerManagement.enable;
      powerManagement.finegrained = cfg.nvidia.powerManagement.finegrained;
      open = false;
      nvidiaSettings = true;

      package =
        let
          kernelPackages = config.boot.kernelPackages;
        in
        if cfg.nvidia.package == "stable" then kernelPackages.nvidiaPackages.stable
        else if cfg.nvidia.package == "beta" then kernelPackages.nvidiaPackages.beta
        else if cfg.nvidia.package == "legacy_470" then kernelPackages.nvidiaPackages.legacy_470
        else if cfg.nvidia.package == "legacy_390" then kernelPackages.nvidiaPackages.legacy_390
        else kernelPackages.nvidiaPackages.stable;

      prime = lib.mkIf cfg.nvidia.prime.enable {
        offload = cfg.nvidia.prime.mode == "offload";
        sync = cfg.nvidia.prime.mode == "sync";
        amdgpuBusId = lib.mkIf (cfg.nvidia.prime.amdgpuBusId != "") cfg.nvidia.prime.amdgpuBusId;
        nvidiaBusId = lib.mkIf (cfg.nvidia.prime.nvidiaBusId != "") cfg.nvidia.prime.nvidiaBusId;
        intelBusId = lib.mkIf (cfg.nvidia.prime.intelBusId != "") cfg.nvidia.prime.intelBusId;
      };
    };

    systemd.services.nvidia-persistenced = lib.mkIf (cfg.nvidia.enable && cfg.nvidia.nvidiaPersistenced) {
      enable = true;
    };

    # Flakes + GC
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };

    # Base packages only
    environment.systemPackages = with pkgs; [
      vim wget curl git htop tree unzip zip
    ];
  };
}
