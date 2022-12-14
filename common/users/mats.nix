{...}: {
  # Mats
  users.users.mats = {
    description = "Mats";
    group = "mats";
    isNormalUser = true;
    createHome = true;
    autoSubUidGidRange = true;
    # Add these extra groups if avaliable
    extraGroups = [
      "audio"
      "dialout"
      "docker"
      "podman"
      "wheel"
      "kvm"
      "media"
      "networkmanager" # Avoid having to type in password all the time
      "libvirtd"
      "wireshark"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPUKK/GkS4KMIbbL2r3qJxV8D6cUDxL/iwbtaOb/9guY" # mats@miyano
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHE9+o74bSCLdPWIgGiF4aEtSY2KUGj3MuOyXvUT4kCw" # mats@mafuyu
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMrDAIMnfHGIYo7EZaFassBU3mddxoDQe7xrjmi0kWuc" # mats@shun
    ];
    uid = 1000;
  };
  # Group
  users.groups.mats = {gid = 1000;};
}
