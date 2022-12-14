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

  # Expose input switches to userspace
  services.udev.extraRules = ''
    KERNEL=="event[0-9]*", ENV{ID_INPUT_SWITCH}=="1", MODE:="0666"
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
