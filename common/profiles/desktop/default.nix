{
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./browsers
    ./editors
    ./modules
    ./audio.nix
    ./fonts.nix
    ./gnome.nix
    ./hardware.nix
    ./home-managar.nix
    ./user.nix
  ];

  # Use latest zen kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Various system packages
  environment.systemPackages = with pkgs; [
    # Base programs
    jetbrains.jdk
    # More XDG
    xdg-user-dirs
    # CLI Tools
    ffmpeg
    yt-dlp
    tokei
    # Media
    calibre
    obs-studio
    # Office / Text
    libreoffice-fresh
    thunderbird
    pympress
    zotero
    # File management
    filezilla
    p7zip
    qdirstat
    # Network
    (lowPrio wireshark)
    networkmanagerapplet
    # Images
    gimp-with-plugins
    # Utilities
    piper # Frontend to ratbagd
    qalculate-gtk
  ];

  # Services
  services.dbus.enable = true;
  services.gvfs.enable = true;
  services.accounts-daemon.enable = true;
  security.polkit.enable = true;
  services.flatpak.enable = true;
  services.ratbagd.enable = true; # Gaming peripheral mgmt
  # Networking
  networking.networkmanager.enable = true;
  # Network debugging
  programs.wireshark.enable = true;
  # Evolution
  programs.evolution.enable = true;

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
}
