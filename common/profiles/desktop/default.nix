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
    barrier
    piper # Frontend to ratbagd
    qalculate-gtk
    cinnamon.warpinator
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
  # Thumbnails
  services.tumbler.enable = true;

  # Enable steam hardware udev rules
  hardware.steam-hardware.enable = true;

  # Extra udev rules
  services.udev.extraRules = ''
    ### Allow Nintendo Switch access through udev
    SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", GROUP="wheel"

    # Switch Joy-con (L) (Bluetooth only)
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:057E:2006.*", MODE="0666"

    # Switch Joy-con (R) (Bluetooth only)
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:057E:2007.*", MODE="0666"

    # Switch Pro controller (USB and Bluetooth)
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", MODE="0666"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:057E:2009.*", MODE="0666"

    # Switch Joy-con charging grip (USB only)
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="200e", MODE="0666"

    # Ducky One 2 RGB TKL
    SUBSYSTEM=="usb", ATTRS{idVendor}=="04d9", ATTRS{idProduct}=="0356", MODE:="0666"
  '';

  # Open ports
  networking.firewall.allowedTCPPorts = [
    # Barrier
    24800
    # Warpinator
    42000
    42001
  ];

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
