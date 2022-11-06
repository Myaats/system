{
  pkgs,
  lib,
  ...
}: {
  # Setup device
  device = {
    uuid = "b97e7998-60bf-42f9-b314-f728de1fd7c7";
    profile = "laptop";
    gpu = "amd";
    touch = true;
  };

  modules.development-tools = {
    cpp = true;
    dotnet = true;
    nix = true;
    python = true;
    rust = true;
    texlive = true;
  };

  # Enable openssh
  services.openssh.enable = true;

  virtualisation.waydroid.enable = true;

  environment.etc."gbinder.d/waydroid.conf".source = lib.mkOverride 50 (pkgs.writeText "waydroid.conf" ''
    [Protocol]
    /dev/binder = aidl3
    /dev/vndbinder = aidl3
    /dev/hwbinder = hidl
    [ServiceManager]
    /dev/binder = aidl3
    /dev/vndbinder = aidl3
    /dev/hwbinder = hidl
  '');

  home-manager.config = {
    # Setup tablet-osk service
    systemd.user.services.tablet-osk = {
      Unit = {
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
      };
      Install.WantedBy = ["graphical-session.target"];
      Service.ExecStart = "${pkgs.local.tablet-osk}/bin/tablet-osk";
    };
  };

  # Allow gnome extension to toggle conservation mode
  security.sudo.extraConfig = ''
    %wheel ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/tee /sys/bus/platform/drivers/ideapad_acpi/VPC????\:??/conservation_mode
  '';

  system.stateVersion = "22.11";
}
