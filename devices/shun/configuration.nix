{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./quirks.nix
  ];

  # Setup device
  device = {
    uuid = "b97e7998-60bf-42f9-b314-f728de1fd7c7";
    profile = "laptop";
    gpu = "amd";
    features = ["ideapad" "touch"];
  };

  # Modules
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

  virtualisation = {
    # Enable virtualbox
    virtualbox.host.enable = true;
    # Enable waydroid
    waydroid.enable = true;
  };

  # Workaround to make waydroid work with the newest ROM
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

  # Set NixOS state version
  system.stateVersion = "22.11";
}
