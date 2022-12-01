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
      systemd-boot.enable = true;
      # allow modifying efi variables
      efi.canTouchEfiVariables = true;
    };
    # init ramdisk
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" "nvme" "tpm_tis"];
      kernelModules = ["amdgpu"];
      # enable systemd in initrd so tpm unlock works
      systemd.enable = true;
      # configure luks w/ tpm unlock
      luks.devices."cryptroot" = {
        device = "/dev/disk/by-uuid/b236ddca-45d5-4786-8157-e4c630fb301c";
        crypttabExtraOpts = ["tpm2-device=auto"];
      };
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
      device = "/dev/mapper/cryptroot";
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
