{...}: {
  # Setup device
  device = {
    uuid = "014e5cd3-2468-4f88-bbf9-7b1f30a4157f";
    profile = "desktop";
  };

  # ZFS requires hostid
  networking.hostId = "b1727a72";

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

  # Set NixOS state version
  system.stateVersion = "22.11";

  # Hardware
  modules.hardware.bluetooth.enable = true; # Enable bluetooth

  # Remove when ZFS is supported officially
  nixpkgs.config.allowBroken = true;

  # Import boot config
  imports = [
    ./boot.nix
  ];
}
