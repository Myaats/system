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
  modules = {
    # Development tools
    development-tools = {
      cpp = true;
      dotnet = true;
      nix = true;
      python = true;
      rust = true;
      texlive = true;
    };
    # Enable mullvad
    services.mullvad = {
      enable = true;
      localNetworkSharing = true;
      location = "no";
    };
  };

  # Enable openssh
  services.openssh.enable = true;

  virtualisation = {
    # Enable virtualbox
    virtualbox.host.enable = true;
  };

  # Set NixOS state version
  system.stateVersion = "22.11";
}
