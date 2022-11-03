{pkgs, ...}: {
  config = {
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
      openssl
      jq
      neofetch
    ];

    # Disable openssh password auth
    services.openssh.
    passwordAuthentication = false;
  };
}
