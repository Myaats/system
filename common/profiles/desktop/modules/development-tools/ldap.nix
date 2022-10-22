{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.development-tools.ldap = mkEnableOption "Enable ldap development-tools";

  config = mkIf config.modules.development-tools.ldap {
    environment.systemPackages = with pkgs; [
      apache-directory-studio
    ];
  };
}
