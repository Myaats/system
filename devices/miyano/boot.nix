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
  # ZFS: Limit the ARC to 6GiB, disable the disk scheduler to make ZFS control the disk
  # AMD PCI passthrough shit
  boot.kernelParams = ["zfs.zfs_arc_max=6442450944" "elevator=none" "nohibernate"];

  # Allow unstable zfs
  boot.zfs.enableUnstable = true;

  boot.loader.grub = {
    enable = true;
    copyKernels = true;
    efiSupport = true;
    fsIdentifier = "label";
    device = "nodev";
    gfxmodeEfi = "1920x1080";
    extraEntries = ''
      menuentry "Windows 11" {
        insmod part_gpt
        insmod fat
        insmod chain
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
    '';
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = ["zfs"];

  fileSystems."/" = {
    device = "rpool/system/root";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "rpool/system/nix";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/user/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7EE5-5EC9";
    fsType = "vfat";
  };

  fileSystems."/mnt/archive" = {
    device = "tank/user/archive";
    fsType = "zfs";
    options = ["rw"];
  };

  fileSystems."/mnt/games" = {
    device = "tank/user/games";
    fsType = "zfs";
    options = ["rw"];
  };

  fileSystems."/mnt/media" = {
    device = "tank/user/media";
    fsType = "zfs";
    options = ["rw"];
  };

  fileSystems."/mnt/vms" = {
    device = "tank/user/vms";
    fsType = "zfs";
    options = ["rw"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/6e730702-1322-4be8-af87-5ccc794077ec";}
  ];

  # Update microcode and enable all firmware
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableAllFirmware = true;
}
