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
      type = lib.types.enum [ "gnome" "kde" "xfce" "none" ];
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable the X11 windowing system
    services.xserver.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Desktop environment specific configuration
    services.displayManager.gdm.enable = lib.mkIf (cfg.desktop == "gnome") true;
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

    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    programs.fish.enable = true;

    # Common desktop packages
    environment.systemPackages = with pkgs; [
      # Basic desktop applications
      firefox
      google-chrome

      # System utilities
      file-roller # archive manager
      gnome-disk-utility

      # Terminal and development
      ghostty
      vscode
      code-cursor
    ] ++ lib.optionals (cfg.desktop == "gnome") [
      # GNOME specific packages
      gnome-tweaks
      gnome-extension-manager
    ] ++ lib.optionals (cfg.desktop == "kde") [
      # KDE specific packages
      kdePackages.kate
      kdePackages.kcalc
      kdePackages.gwenview
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
