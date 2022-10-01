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
    mpv
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
    # Images
    gimp-with-plugins
  ];

  # Graphics acceleration
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      libGL
    ];
    setLdLibraryPath = true;
  };

  # Services
  services.dbus.enable = true;
  services.gvfs.enable = true;
  services.accounts-daemon.enable = true;
  security.polkit.enable = true;
  services.flatpak.enable = true;
  # Networking
  networking.networkmanager.enable = true;
  # Network debugging
  programs.wireshark.enable = true;
}
