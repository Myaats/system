{
  lib,
  pkgs,
  ...
}:
with lib; {
  home-manager.config = {config, ...}: {
    # Enable mpv with vaapi/gpu
    programs.mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [
        inhibit-gnome
      ];
      config = {
        hwdec = "vaapi";
        vo = "gpu";
      };
    };

    # Update jellyfin-mpv-shim settings to use home-manager mpv with scripts
    home.activation.jellyfin-mpv-shim-conf = config.lib.dag.entryAfter ["writeBoundary"] (mergeJson "~/.config/jellyfin-mpv-shim/conf.json" {
      mpv_ext = true;
      mpv_ext_path = "/etc/profiles/per-user/${config.home.username}/bin/mpv";
    });
  };

  # Install jellyfin-mpv-shim
  environment.systemPackages = [pkgs.jellyfin-mpv-shim];
}
