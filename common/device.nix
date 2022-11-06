{
  config,
  lib,
  deviceArgs,
  ...
}:
with lib; {
  options.device = {
    uuid = mkOption {
      type = types.str;
      description = "UUID for device";
    };
    hostName = mkOption {
      type = types.str;
      description = "Hostname for device";
    };
    profile = mkOption {
      type = types.enum ["desktop" "laptop"];
    };
    gpu = mkOption {
      type = types.nullOr (types.enum ["amd" "intel"]);
    };
    features = mkOption {
      type = types.listOf (types.enum ["ideapad" "touch"]);
      default = [];
    };
  };

  config = mkMerge [
    {
      # Get hostname from flake.nix
      device.hostName = mkDefault deviceArgs.hostName;
      # Use the hostName provided by flake.nix
      networking.hostName = config.device.hostName;
    }
    ### Features for devices
    # Ideapad features
    (mkIf (builtins.elem "ideapad" config.device.features) {
      # Allow gnome extension to toggle conservation mode
      security.sudo.extraConfig = ''
        %wheel ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/tee /sys/bus/platform/drivers/ideapad_acpi/VPC????\:??/conservation_mode
      '';
    })
  ];
}
