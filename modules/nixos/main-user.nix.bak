# Main user configuration module
{ lib, config, pkgs, ... }:

let
  cfg = config.main-user;
in
{
  options.main-user = {
    enable = lib.mkEnableOption "enable user module";

    userName = lib.mkOption {
      default = "mainuser";
      description = "Username for the main user";
      type = lib.types.str;
    };

    userFullName = lib.mkOption {
      default = "Main User";
      description = "Full name for the main user";
      type = lib.types.str;
    };

    shell = lib.mkOption {
      default = pkgs.fish;
      description = "Default shell for the user";
      type = lib.types.package;
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
      isNormalUser = true;
      initialPassword = "password"; # Change this on first login!
      description = cfg.userFullName;
      shell = cfg.shell;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
        "docker"
        "libvirtd"
      ];
    };

    # Enable sudo for wheel group
    security.sudo.wheelNeedsPassword = false;
  };
}
