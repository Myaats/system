{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Boot
  boot = {
    # boot loader (systemd-boot)
    loader = {
      systemd-boot.enable = true;
      # allow modifying efi variables
      efi.canTouchEfiVariables = true;
    };
    # init ramdisk
    initrd = {
      availableKernelModules = ["xhci_pci" "usb_storage" "usbhid" "sd_mod" "sdhci_pci" "nvme" "tpm_tis"];
      kernelModules = [];
      # enable systemd in initrd so tpm unlock works
      systemd.enable = true;
      # configure luks w/ tpm unlock
      luks.devices."cryptroot" = {
        device = "/dev/disk/by-uuid/eab5ccb7-ab0f-4666-9d32-ba456aff421f";
        crypttabExtraOpts = ["tpm2-device=auto"];
      };
    };
    # kernel
    kernelPackages = lib.mkForce pkgs.linuxPackages_xanmod_latest;
    extraModulePackages = with config.boot.kernelPackages; [zenpower];
    kernelModules = ["kvm-amd" "amd_pstate" "zenpower" "snd_soc_tas2562"];
    blacklistedKernelModules = ["acpi_cpufreq" "k10temp"]; # Disable ACPI cpufreq (in favor of p-state), and k10temp for zenpower
  };

  # Mount filesystems
  fileSystems = {
    "/" = {
      device = "/dev/mapper/cryptroot";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/B3FA-1B08";
      fsType = "vfat";
    };
  };

  swapDevices = [];
  zramSwap.enable = true; # Enable zram

  # Hardware
  hardware = {
    # enable all firmware
    enableAllFirmware = true;
    # enable cpu microcode updates
    cpu.amd.updateMicrocode = true;
    # high-resolution display
    video.hidpi.enable = true;
    # iio sensors
    sensor.iio.enable = true;
    # extra firmware
    firmware = [pkgs.local.tas2563-fw];
  };
}
