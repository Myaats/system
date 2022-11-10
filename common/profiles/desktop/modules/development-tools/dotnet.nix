{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.development-tools.dotnet = mkEnableOption "Enable dotnet development-tools";

  config = mkIf config.modules.development-tools.dotnet {
    environment.systemPackages = with pkgs; [
      (with dotnetCorePackages;
        combinePackages [
          sdk_6_0
          sdk_7_0
        ])
      omnisharp-roslyn
    ];

    # Telemetry opt-out
    home-manager.config.home.sessionVariables.DOTNET_CLI_TELEMETRY_OPTOUT = "1";
  };
}
