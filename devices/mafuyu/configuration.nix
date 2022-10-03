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

  # Enable legacy renegotiation to fix eduroam access
  systemd.services.wpa_supplicant.environment.OPENSSL_CONF = pkgs.writeText "openssl.cnf" ''
    openssl_conf = openssl_init

    [openssl_init]
    ssl_conf = ssl_sect

    [ssl_sect]
    system_default = system_default_sect

    [system_default_sect]
    Options = UnsafeLegacyRenegotiation
  '';

  system.stateVersion = "22.11";

  # Import boot config
  imports = [
    ./boot.nix
  ];
}
