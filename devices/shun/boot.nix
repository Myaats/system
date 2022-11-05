{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  # Command to fix speakers
  fix-speakers = "${pkgs.i2c-tools}/bin/i2cset -y 3 0x48 0x2 0 && ${pkgs.i2c-tools}/bin/i2cset -y 3 0x48 0x3 0";
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel
  boot.initrd.availableKernelModules = ["xhci_pci" "usb_storage" "usbhid" "sd_mod" "sdhci_pci" "nvme" "tpm_tis"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd" "amd_pstate"];
  boot.blacklistedKernelModules = ["acpi_cpufreq"]; # Disable ACPI cpufreq (in favor of p-state)
  # Kernel patches
  boot.kernelPatches = [
    # Fix s2idle
    {
      name = "Fixups for s2idle on various Rembrandt laptops";
      patch = pkgs.fetchpatch {
        name = "Fixups-for-s2idle-on-various-Rembrandt-laptops.patch";
        url = "https://patchwork.kernel.org/series/679149/mbox/";
        sha256 = "sha256-wDpuOZz3WowVmw+GbDn2GVXhopbqkxvAvyULWPBuLJk=";
      };
    }
    # Fix tablet mode
    {
      name = "[RFC] Add Lenovo Yoga Mode Control driver";
      patch = pkgs.fetchpatch {
        name = "Add-Lenovo-Yoga-Mode-Control-driver.patch";
        url = "https://patchwork.kernel.org/series/683100/mbox/";
        sha256 = "sha256-wzDyEEoHnUrvJWYNO9ymILTdM1A0dTZz1BYiTJALBA8=";
      };
    }
  ];
  # Setup LUKS
  boot.initrd.systemd.enable = true;
  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/eab5ccb7-ab0f-4666-9d32-ba456aff421f";
    crypttabExtraOpts = ["tpm2-device=auto"];
  };

  fileSystems."/" = {
    device = "/dev/mapper/cryptroot";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B3FA-1B08";
    fsType = "vfat";
  };

  swapDevices = [];
  zramSwap.enable = true; # Enable zram

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableAllFirmware = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
  # iio sensors
  hardware.sensor.iio.enable = true;
  # enable i2c (needed to fix speaker setup)
  hardware.i2c = {
    enable = true;
    group = "wheel";
  };
  # set the audio fix registers (14ARB7) https://github.com/PJungkamp/yoga9-linux/issues/8#issuecomment-1265454056
  systemd = {
    user.services.fix-yoga-speakers-boot = {
      wantedBy = ["pipewire.service"];
      after = ["pipewire.service"];
      bindsTo = ["pipewire.service"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.bash}/bin/bash -c '${fix-speakers}'";
      };
    };
    services.fix-yoga-speakers-suspend = {
      wantedBy = ["suspend.target"];
      after = ["suspend.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.bash}/bin/bash -c '${fix-speakers}'";
      };
    };
  };
  # fix incorrect power saving on audio controller
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0 power_save_controller=N
  '';
  # Setup acpid
  services.acpid = {
    enable = true;
    handlers = {
      # Fix speakers after headphone unplug
      headphone-unplugged = {
        action = fix-speakers;
        event = "jack/headphone HEADPHONE unplug";
      };
    };
  };
  # Expose input switches to userspace
  services.udev.extraRules = ''
    KERNEL=="event[0-9]*", ENV{ID_INPUT_SWITCH}=="1", MODE:="0666"
  '';
}
