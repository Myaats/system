{...}: {
  # Setup device
  device = {
    uuid = "d58ed897-5a81-412c-980f-65476f622633";
    profile = "laptop";
  };

  modules.development-tools = {
    dotnet = true;
    nix = true;
    python = true;
    rust = true;
  };

  system.stateVersion = "22.11";

  # Import boot config
  imports = [
    ./boot.nix
  ];
}
