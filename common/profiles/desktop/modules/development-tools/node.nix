{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.development-tools.node = mkEnableOption "Enable node development-tools";

  config = mkIf config.modules.development-tools.node {
    environment.systemPackages = with pkgs; [
      nodejs
      yarn
    ];
  };
}
