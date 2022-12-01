{pkgs, ...}: {
  imports = [
    # Inherit desktop profile
    ../desktop
  ];

  # All my laptops have bluetooth I guess.
  modules.hardware.bluetooth.enable = true;

  # Setup powertop
  powerManagement.powertop.enable = true;
  environment.systemPackages = [pkgs.powertop];
}
