{pkgs, ...}: {
  # Setup device
  device = {
    uuid = "d58ed897-5a81-412c-980f-65476f622633";
    profile = "laptop";
    gpu = "intel";
  };

  modules.development-tools = {
    cpp = true;
    dotnet = true;
    nix = true;
    python = true;
    rust = true;
    texlive = true;
  };

  system.stateVersion = "22.11";

  # Import boot config
  imports = [
    ./boot.nix
  ];
}
