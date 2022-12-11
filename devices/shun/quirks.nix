{
  config,
  pkgs,
  ...
}: let
  kmod_ver = config.boot.kernelPackages.kernel.modDirVersion;
in {
  modules.boot.kernelModulePatches = [
    # Add driver for Lenovo YMC (WMI)
    {
      name = "[RFC] Add Lenovo Yoga Mode Control driver";
      patches = [
        (pkgs.fetchpatch {
          name = "Add-Lenovo-Yoga-Mode-Control-driver.patch";
          url = "https://patchwork.kernel.org/series/683100/mbox/";
          sha256 = "sha256-wzDyEEoHnUrvJWYNO9ymILTdM1A0dTZz1BYiTJALBA8=";
        })
      ];
      modules = ["drivers/platform/x86/ideapad-laptop" "drivers/platform/x86/lenovo-ymc"];
    }
    {
      name = "Build tas2562 driver w/ patches";
      patches = [./tas2563-acpi.diff];
      modules = ["sound/soc/codecs/snd-soc-tas2562"];
    }
  ];

  hardware.i2c = {
    enable = true;
    group = "wheel";
  };

  # Create wrapped script to fix the tas2563
  security.wrappers.fix-tas2563 = {
    capabilities = "cap_sys_module+ep";
    owner = "root";
    group = "root";
    source = "${pkgs.runCommandCC "fix-tas2563" {
        nativeBuildInputs = [pkgs.makeWrapper];
      }
      ''
        mkdir -p $out/bin
        cp -p ${pkgs.writeScript "fix-tas2563" ''
          ${pkgs.kmod}/bin/rmmod snd_soc_tas2562
          ${pkgs.kmod}/bin/insmod /run/current-system/kernel-modules/lib/modules/${kmod_ver}/kernel/sound/soc/codecs/snd-soc-tas2562.ko.xz
        ''} $out/bin/fix-tas2563
        wrapProgram $out/bin/fix-tas2563
      ''}/bin/fix-tas2563";
  };

  systemd.services.fix-yoga-speakers-suspend = {
    wantedBy = ["suspend.target"];
    after = ["suspend.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "/run/wrappers/bin/fix-tas2563";
    };
  };

  services.acpid = {
    enable = true;
    handlers = {
      # Fix speakers after headphone unplug
      headphone-unplugged = {
        action = "/run/wrappers/bin/fix-tas2563";
        event = "jack/headphone HEADPHONE unplug";
      };
    };
  };

  # Expose input switches to userspace
  services.udev.extraRules = ''
    KERNEL=="event[0-9]*", ENV{ID_INPUT_SWITCH}=="1", MODE:="0666"
  '';

  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0 power_save_controller=N
  '';

  # Setup user services
  home-manager.config = {
    # Setup tablet-osk service to toggle touch keyboard
    systemd.user.services.tablet-osk = {
      Unit = {
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
      };
      Install.WantedBy = ["graphical-session.target"];
      Service.ExecStart = "${pkgs.local.tablet-osk}/bin/tablet-osk";
    };
  };
}
