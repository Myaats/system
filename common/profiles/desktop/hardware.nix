{
  config,
  pkgs,
  ...
}: {
  # Graphics acceleration
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs;
      [
        libGL
        # Video acceleration
        vaapiVdpau
        libvdpau-va-gl
      ]
      # Add intel specific packages for video acceleration
      ++ (
        if config.device.gpu == "intel"
        then [
          intel-media-driver
          vaapiIntel
        ]
        else []
      );
    setLdLibraryPath = true;
  };

  home-manager.config = {
    # Enable mpv with vaapi/gpu
    programs.mpv = {
      enable = true;
      config = {
        hwdec = "vaapi";
        vo = "gpu";
      };
    };
  };
}
