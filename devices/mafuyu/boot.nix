{
  pkgs,
  nixpkgs,
  lib,
  ...
}: {
  imports = [
    "${nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  boot.loader.grub = {
    enable = true;
    copyKernels = true;
    efiSupport = true;
    fsIdentifier = "label";
    device = "nodev";
    gfxmodeEfi = "1920x1080";
    extraEntries = ''
      menuentry "Windows 10" {
        insmod part_gpt
        insmod fat
        insmod chain
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
    '';
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9b78603c-f1b4-4b41-be8f-8265f0efccc8";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C688-8C44";
    fsType = "vfat";
  };

  swapDevices = [{device = "/dev/disk/by-uuid/fdc57c2b-a2b5-43b4-9eb9-f9ac3035f91d";}];

  # Updates
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableAllFirmware = true;

  nix.settings.max-jobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
