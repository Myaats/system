{
  config,
  lib,
  ...
}:
with lib; {
  # Use my own domain, primarily for DNS
  networking = {
    domain = "mats.sh";
    search = ["mats.sh"];
    # Network manager
    networkmanager.enable = true;
    # Firewall
    firewall = {
      # Open TCP ports
      allowedTCPPorts = [
        # Barrier
        24800
        # Warpinator
        42000
        42001
      ];

      # Fix for VPNs
      checkReversePath = "loose";
    };
    # Get resolvconf to behave
    resolvconf = {
      enable = true;
      # Force resolvconf to pick it up
      extraConfig = ''
        search_domains='${concatStringsSep " " config.networking.search}'
      '';
    };
  };

  # Network debugging - wireshark
  programs.wireshark.enable = true;

  # Enable tailscale
  services.tailscale.enable = true;
}
