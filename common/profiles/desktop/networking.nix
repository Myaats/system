{...}: {
  # Use my own domain, primarily for DNS
  networking = {
    domain = "mats.sh";
    search = ["mats.sh"];
  };

  # Network manager
  networking.networkmanager.enable = true;

  # Network debugging - wireshark
  programs.wireshark.enable = true;

  # Enable tailscale
  services.tailscale.enable = true;
  # Fix for VPNs
  networking.firewall.checkReversePath = "loose";

  # Open ports
  networking.firewall.allowedTCPPorts = [
    # Barrier
    24800
    # Warpinator
    42000
    42001
  ];
}
