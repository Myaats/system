{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.development-tools.steamos = mkEnableOption "Enable SteamOS related development tools";

  config = mkIf config.modules.development-tools.steamos {
    environment.systemPackages = with pkgs; [
      steamos-devkit
    ];
  };
}
