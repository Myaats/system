{
  config,
  pkgs,
  lib,
  nixpkgs,
  ...
}: {
  imports = [
    "${nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" "nvme"];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModprobeConfig = ''
    options kvm_amd nested=1
  '';
  boot.extraModulePackages = [];

  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "auto";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3cb30f35-12ca-48d5-81e5-fafe7f8d0ca3";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B5AC-C207";
    fsType = "vfat";
  };

  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/21e08739-38ce-4fff-9f35-a762cf1413fc";
    fsType = "ext4";
  };

  # Use zram for swapping
  zramSwap.enable = true;

  # Update microcode and enable all firmware
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableAllFirmware = true;
}
