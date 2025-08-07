{ lib, ... }:

let
  isCIBuild = builtins.getEnv "NIXOS_CI_BUILD" == "true";
in
lib.mkIf isCIBuild {
  # CI overrides: keep kernel module discovery intact to avoid missing
  # linux-*modules-shrunk paths. Only disable hardware-dependent extras.

  boot.kernel.sysctl = lib.mkForce { };

  hardware.cpu.intel.updateMicrocode = lib.mkForce false;
  hardware.cpu.amd.updateMicrocode = lib.mkForce false;
  hardware.enableRedistributableFirmware = lib.mkForce false;
  hardware.firmware = lib.mkForce [ ];

  hardware.nvidia = lib.mkForce { enable = false; };
  services.xserver.videoDrivers = lib.mkForce [ ];

  services.pulseaudio.enable = lib.mkForce false;
  services.pipewire.enable = lib.mkForce false;
  security.rtkit.enable = lib.mkForce false;

  # Avoid disabling udev or clearing fileSystems here (keeps evaluation stable)
}