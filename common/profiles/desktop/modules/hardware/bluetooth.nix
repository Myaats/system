{
  config,
  lib,
  ...
}:
with lib; {
  options.modules.hardware.bluetooth.enable = mkEnableOption "Enable bluetooth services";

  config = mkIf config.modules.hardware.bluetooth.enable {
    services.blueman.enable = true;
    hardware.bluetooth.enable = true;
  };
}
