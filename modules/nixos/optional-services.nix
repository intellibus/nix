# Optional services configuration module
{ lib, config, pkgs, ... }:

let
  cfg = config.optional-services;
in
{
  options.optional-services = {
    docker = {
      enable = lib.mkEnableOption "Docker containerization platform";
    };

    virtualization = {
      enable = lib.mkEnableOption "KVM/QEMU virtualization";
    };

    printing = {
      enable = lib.mkEnableOption "CUPS printing service";
    };

    bluetooth = {
      enable = lib.mkEnableOption "Bluetooth support";
    };

    steam = {
      enable = lib.mkEnableOption "Steam gaming platform";
    };

    flatpak = {
      enable = lib.mkEnableOption "Flatpak application sandboxing";
    };

    zsh = {
      enable = lib.mkEnableOption "Zsh as system shell";
    };
  };

  config = lib.mkMerge [
    # Docker configuration
    (lib.mkIf cfg.docker.enable {
      virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
      };
      users.users.${config.main-user.userName}.extraGroups = [ "docker" ];
    })

    # Virtualization configuration
    (lib.mkIf cfg.virtualization.enable {
      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = false;
        };
      };
      programs.virt-manager.enable = true;
      users.users.${config.main-user.userName}.extraGroups = [ "libvirtd" ];
    })

    # Printing configuration
    (lib.mkIf cfg.printing.enable {
      services.printing = {
        enable = true;
        drivers = with pkgs; [
          gutenprint
          hplip
          epson-escpr
          cnijfilter2
        ];
      };
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    })

    # Bluetooth configuration
    (lib.mkIf cfg.bluetooth.enable {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Enable = "Source,Sink,Media,Socket";
          };
        };
      };
      services.blueman.enable = true;
    })

    # Steam configuration
    (lib.mkIf cfg.steam.enable {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };
      hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
    })

    # Flatpak configuration
    (lib.mkIf cfg.flatpak.enable {
      services.flatpak.enable = true;
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];
      };
    })

    # Zsh configuration
    (lib.mkIf cfg.zsh.enable {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
      };
      users.defaultUserShell = pkgs.zsh;
      environment.shells = with pkgs; [ zsh ];
    })
  ];
}
