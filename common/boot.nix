{...}: {
  boot = {
    # Clean /tmp on boot
    cleanTmpDir = true;
    loader = {
      # Disable bootloader timeout (just press a key to show it)
      timeout = 0;
      # Harden systemd-boot
      systemd-boot.editor = false;
    };
  };
}
