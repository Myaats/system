{pkgs, ...}: {
  home-manager.config = {
    # Enable mpv with vaapi/gpu
    programs.mpv = {
      enable = true;
      scripts = [
        pkgs.local.mpv-inhibit-gnome
      ];
      config = {
        hwdec = "vaapi";
        vo = "gpu";
      };
    };
  };

  # Install jellyfin-mpv-shim
  environment.systemPackages = [pkgs.jellyfin-mpv-shim];
}
