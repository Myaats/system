{...}: {
  # Setup device
  device = {
    uuid = "014e5cd3-2468-4f88-bbf9-7b1f30a4157f";
    profile = "desktop";
    gpu = "amd";
  };

  # ZFS requires hostid
  networking.hostId = "b1727a72";

  modules.development-tools = {
    cpp = true;
    database.postgres = true;
    dotnet = true;
    ldap = true;
    nix = true;
    node = true;
    podman = true;
    python = true;
    rust = true;
    steamos = true;
    texlive = true;
  };

  # Enable openssh
  services.openssh.enable = true;

  # Hardware
  modules.hardware.bluetooth.enable = true; # Enable bluetooth

  # Enable mullvad
  modules.services.mullvad = {
    enable = true;
    localNetworkSharing = true;
    location = "no";
  };

  # Set NixOS state version
  system.stateVersion = "22.11";
}
