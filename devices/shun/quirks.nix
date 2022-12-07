{pkgs, ...}: let
  # Command to fix speakers
  fix-speakers = "${pkgs.i2c-tools}/bin/i2cset -y 3 0x48 0x2 0 && ${pkgs.i2c-tools}/bin/i2cset -y 3 0x48 0x3 0";
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
  ];

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
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/sleep 4 && ${fix-speakers}'";
      };
    };
  };

  # fix incorrect power saving on audio controller
  #boot.extraModprobeConfig = ''
  #  options snd_hda_intel power_save=0 power_save_controller=N
  #'';

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
