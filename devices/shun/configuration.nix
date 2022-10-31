{pkgs, ...}: {
  # Setup device
  device = {
    uuid = "b97e7998-60bf-42f9-b314-f728de1fd7c7";
    profile = "laptop";
    gpu = "amd";
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
}
