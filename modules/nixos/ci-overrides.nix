{ lib, ... }:

let
  isCIBuild = builtins.getEnv "NIXOS_CI_BUILD" == "true";
in
lib.mkIf isCIBuild {
  # Completely disable kernel modules and hardware-dependent services
  boot.initrd.availableKernelModules = lib.mkForce [ ];
  boot.kernelModules = lib.mkForce [ ];
  boot.extraModulePackages = lib.mkForce [ ];
  boot.kernelPackages = lib.mkForce null;
  boot.kernel.sysctl = lib.mkForce { };

  hardware.cpu.intel.updateMicrocode = lib.mkForce false;
  hardware.cpu.amd.updateMicrocode = lib.mkForce false;
  hardware.enableRedistributableFirmware = lib.mkForce false;
  hardware.firmware = lib.mkForce [ ];

  # Disable all NVIDIA and graphics-related configs
  hardware.nvidia = lib.mkForce { };
  services.xserver.videoDrivers = lib.mkForce [ ];

  # Disable sound and other hardware services
  services.pulseaudio.enable = lib.mkForce false;
  services.pipewire.enable = lib.mkForce false;
  security.rtkit.enable = lib.mkForce false;

  # Disable any other hardware-dependent services as needed
}