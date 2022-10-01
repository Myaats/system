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
      dotnet-sdk_6
      omnisharp-roslyn
    ];

    environment.variables = {
      DOTNET_CLI_TELEMETRY_OPTOUT = "1";
      DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1";
    };
  };
}
