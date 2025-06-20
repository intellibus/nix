# Desktop environment configuration module
{ lib, config, pkgs, ... }:

let
  cfg = config.desktop-environment;
in
{
  options.desktop-environment = {
    enable = lib.mkEnableOption "enable desktop environment module";

    desktop = lib.mkOption {
      default = "gnome";
      description = "Desktop environment to use";
      type = lib.types.enum [ "gnome" "kde" "xfce" "hyprland" "none" ];
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable the X11 windowing system for traditional desktop environments
    services.xserver.enable = lib.mkIf (cfg.desktop != "hyprland") true;

    # Configure keymap in X11
    services.xserver.xkb = lib.mkIf (cfg.desktop != "hyprland") {
      layout = "us";
      variant = "";
    };

    # Hyprland specific configuration
    programs.hyprland.enable = lib.mkIf (cfg.desktop == "hyprland") true;

    # Enable XDG Desktop Portal for Hyprland
    xdg.portal = lib.mkIf (cfg.desktop == "hyprland") {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };

    # Desktop environment specific configuration
    services.displayManager.gdm = {
      enable = lib.mkIf (cfg.desktop == "gnome" || cfg.desktop == "hyprland") true;
      wayland = lib.mkIf (cfg.desktop == "hyprland") true;
    };
    services.desktopManager.gnome.enable = lib.mkIf (cfg.desktop == "gnome") true;

    services.displayManager.sddm.enable = lib.mkIf (cfg.desktop == "kde") true;
    services.desktopManager.plasma6.enable = lib.mkIf (cfg.desktop == "kde") true;

    services.xserver.displayManager.lightdm.enable = lib.mkIf (cfg.desktop == "xfce") true;
    services.xserver.desktopManager.xfce.enable = lib.mkIf (cfg.desktop == "xfce") true;

    # GNOME specific configuration
    environment.gnome.excludePackages = lib.mkIf (cfg.desktop == "gnome") (with pkgs; [
      gnome-photos
      gnome-tour
      gedit # text editor
    ]);

    # Install Firefox
    programs.firefox.enable = true;

    # Common desktop packages
    environment.systemPackages = with pkgs; [
      # Basic desktop applications
      firefox
      thunderbird
      libreoffice
      vlc
      gimp

      # System utilities
      file-roller # archive manager
      gnome-disk-utility

      # Terminal and development
      gnome-terminal
      vscode
    ] ++ lib.optionals (cfg.desktop == "gnome") [
      # GNOME specific packages
      gnome-tweaks
      gnome-extension-manager
    ] ++ lib.optionals (cfg.desktop == "kde") [
      # KDE specific packages
      kdePackages.kate
      kdePackages.kcalc
      kdePackages.gwenview
    ] ++ lib.optionals (cfg.desktop == "hyprland") [
      # Hyprland specific packages
      kitty # Required for default Hyprland config
      wofi # App launcher
      waybar # Status bar
      mako # Notification daemon
      swww # Wallpaper daemon
      grimblast # Screenshot tool
      slurp # Screen area selection
      wl-clipboard # Clipboard utilities
      brightnessctl # Brightness control
      pamixer # Audio control
      playerctl # Media control
      hyprpaper # Wallpaper utility
      hyprlock # Screen locker
      hypridle # Idle management
      hyprpicker # Color picker
      xdg-desktop-portal-hyprland
      polkit-kde-agent # Authentication agent
    ];

    # Fonts
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
    ];
  };
}
