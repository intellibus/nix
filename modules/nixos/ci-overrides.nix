{ lib, ... }:

{
  # CI overrides always applied for this host (no env var detection)

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