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
  };

  config = {
    # Get hostname from flake.nix
    device.hostName = mkDefault deviceArgs.hostName;
    # Use the hostName provided by flake.nix
    networking.hostName = config.device.hostName;
  };
}
