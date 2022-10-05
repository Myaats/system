{
  config,
  lib,
  ...
}:
with lib; {
  imports = [
    # Inherit desktop profile
    ../desktop
  ];

  # All my laptops have bluetooth I guess.
  modules.hardware.bluetooth.enable = true;
}
