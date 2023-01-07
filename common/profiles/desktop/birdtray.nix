{
  config,
  lib,
  pkgs,
  ...
}:
# Disable on laptops
lib.mkIf (config.device.profile
  != "laptop") {
  # Home config for mats on desktop profile
  home-manager.config = {config, ...}: {
    # Birdtray service
    systemd.user.services.birdtray = {
      Unit = {
        After = ["graphical-session.target"];
        Requires = ["graphical-session.target"];
      };
      Service = {
        ExecStart = "${pkgs.birdtray}/bin/birdtray";
        # Birdtray cannot control thunderbird if wayland is enabled...
        Environment = "MOZ_ENABLE_WAYLAND=0";
      };
      Install.WantedBy = ["graphical-session.target"];
    };

    # Update birdtray config
    home.activation.update-birdtray-config = config.lib.dag.entryAfter ["writeBoundary"] (lib.mergeJson "~/.config/birdtray-config.json" {
      "advanced/runProcessOnChange" = "";
      "advanced/tbcmdline" = [
        "/run/current-system/sw/bin/thunderbird"
      ];
      "advanced/tbwindowmatch" = " Mozilla Thunderbird";
      "common/hidewhenminimized" = true;
      "common/hidewhenrestarted" = true;
      "common/hidewhenstarted" = true;
      "common/launchthunderbird" = true;
      "common/restartthunderbird" = true;
      "common/showhidethunderbird" = true;
      # Custom thunderbird monochrome svg icon
      "common/notificationicon" = "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";
    });
  };
}
