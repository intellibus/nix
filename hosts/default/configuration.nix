# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # GitHub Actions runner host
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/ci-overrides.nix
  ];

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
    };
  };

  main-user = {
    enable = true;
    userName = "absurdprofit";
  };

  system-config = {
    enable = true;
    hostname = "nixos";

    # NVIDIA Graphics Configuration (always off in CI)
    nvidia = {
      enable = false;
      package = "stable";
      opengl = false;
      modesetting = false;
      nvidiaPersistenced = false;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      prime = {
        enable = false;
        mode = "sync";
        nvidiaBusId = "";
        intelBusId = "";
        amdgpuBusId = "";
      };
    };
  };

  desktop-environment = {
    enable = true;
  };

  # Optional services (keep disabled for CI)
  optional-services = {
    docker.enable = false;
    virtualization.enable = false;
    printing.enable = false;
    bluetooth.enable = false;
    steam.enable = false;
    flatpak.enable = false;
    fish.enable = true;
  };

  system.stateVersion = "24.05";
}
