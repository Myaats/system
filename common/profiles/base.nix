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
      MIIBiTCCAS+gAwIBAgIRAMwv6VB4SyeRzZfhXnBKPuEwCgYIKoZIzj0EAwIwETEP
      MA0GA1UEAxMGY2EubGFuMB4XDTIyMTEwNTIyNDYwNFoXDTIyMTEwNjIyNDYwNFow
      ETEPMA0GA1UEAxMGY2EubGFuMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEJmQq
      CaqjHj2EYBUEePGO04ZJ3WCxwJ6Wo7f/K0e38n/b82/YURtzgP2Rin1qwl4exkjO
      U5MSc9RNwmy66zZXuqNoMGYwDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYB
      Af8CAQEwHQYDVR0OBBYEFDmQjbHpdGXFCOpYFgjxNqTb6M5WMCEGA1UdHgEB/wQX
      MBWgEzAFggNsYW4wCocICgAAAP8AAAAwCgYIKoZIzj0EAwIDSAAwRQIgdOp0wYeO
      UANKw+L7a59Sy6rE11mmS1hUFdP7Yd8R/usCIQDZ9h0nyaBaRl3Rb68NVNJ8wqEz
      WpWqcwqa/J6uVVty+w==
      -----END CERTIFICATE-----
    ''
  ];
}
