{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Files
    bat
    exa
    file
    ripgrep
    # Editing
    vim
    # Network
    curl
    wget
    ldns
    wget
    dnsutils
    iftop
    traceroute
    nmap
    whois
    # System
    pciutils
    usbutils
    smartmontools
    htop
    btop
    # Archives
    zip
    unrar
    # Multiplexing
    screen
    tmux
    # VCS
    gitFull
    gitAndTools.git-subrepo
    git-crypt
    # Misc
    cryptsetup
    openssl
    jq
    neofetch
  ];

  # Disable openssh password auth
  services.openssh.passwordAuthentication = false;

  # Trust .lan constrained CA
  security.pki.certificates = [
    ''
      .lan
      ====
      -----BEGIN CERTIFICATE-----
      MIIBhzCCAS6gAwIBAgIQKz1goti5k0Ecxi1P2jBqCzAKBggqhkjOPQQDAjARMQ8w
      DQYDVQQDEwZjYS5sYW4wHhcNMjIxMTA3MDgyODE5WhcNMzIxMTA0MDgyODE5WjAR
      MQ8wDQYDVQQDEwZjYS5sYW4wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAAQoNOE1
      tPuCHeobEbZ5AdHs7Hnfwx0B0AVx+sVCw6uBHAIb+0PcaNQI6CRCkVPHq/2laXdN
      cS2XgsuSqjfKgyYno2gwZjAOBgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB
      /wIBATAdBgNVHQ4EFgQU3Mjcwl69u8snBDklz7yHoM66+aMwIQYDVR0eAQH/BBcw
      FaATMAWCA2xhbjAKhwgKAAAA/wAAADAKBggqhkjOPQQDAgNHADBEAiB1INO6Shvg
      VdR3qfme3AFdLIEslNUGOjLQbruxdeDAogIgZoXGhGtnwmPkTgMBgm3RSNAEykmQ
      iOb2GMZvy9CHF70=
      -----END CERTIFICATE-----
    ''
  ];
}
