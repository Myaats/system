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

  boot = {
    # boot loader (systemd-boot)
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
      };
      # allow modifying efi variables
      efi.canTouchEfiVariables = true;
    };
    # init ramdisk
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" "nvme"];
      kernelModules = ["amdgpu"];
    };
    # kernel
    kernelModules = ["kvm-amd"];
    extraModprobeConfig = ''
      options kvm_amd nested=1
    '';
    extraModulePackages = [];
  };

  # Mounted filesystems

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/3cb30f35-12ca-48d5-81e5-fafe7f8d0ca3";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/B5AC-C207";
      fsType = "vfat";
    };

    "/mnt/hdd" = {
      device = "/dev/disk/by-uuid/21e08739-38ce-4fff-9f35-a762cf1413fc";
      fsType = "ext4";
    };
  };

  # Use zram for swapping
  zramSwap.enable = true;

  # Hardware
  hardware = {
    # Enable all firmware
    enableAllFirmware = true;
    # Enable AMD CPU microcode updates
    cpu.amd.updateMicrocode = true;
  };
}
