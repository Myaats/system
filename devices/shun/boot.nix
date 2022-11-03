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
  boot.initrd.availableKernelModules = ["xhci_pci" "usb_storage" "usbhid" "sd_mod" "sdhci_pci" "acpi_call"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = with config.boot.kernelPackages; [acpi_call];
  boot.blacklistedKernelModules = ["nvme"]; # Disable NVMe until firmware is fixed
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

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1d3fc2ea-1b74-4281-a9e3-7ec653660c6a";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2E7C-B44E";
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
  hardware.i2c.enable = true;
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
