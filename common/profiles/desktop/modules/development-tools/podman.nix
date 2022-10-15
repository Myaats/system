{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.development-tools.podman = mkEnableOption "Enable podman development-tools";

  config = mkIf config.modules.development-tools.podman {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };

    environment.systemPackages = with pkgs; [
      podman-compose
    ];
  };
}
