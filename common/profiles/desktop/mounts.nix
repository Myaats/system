{...}: let
  mountNfs = host: mount: {
    fsType = "nfs";
    device = "${host}:${mount}";
    options = [
      # Do not auto mount
      "noauto"
      # Avoid spamming access time updates
      "relatime"
      # Give up NFS mounting after 2s
      "timeo=20"
      # Automount w/ systemd
      "x-systemd.automount"
      "x-systemd.mount-timeout=10"
      # Auto unmount after 10 min of idle
      "x-systemd.idle-timeout=10min"
    ];
  };
in
{
  fileSystems = {
    "/run/mount/archive" = mountNfs "shion" "/mnt/archive";
    "/run/mount/media" = mountNfs "shion" "/mnt/media";
  };
}
