{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.development-tools.cloud;
in {
  options.modules.development-tools.cloud = {
    aws = mkEnableOption "Enable AWS cloud tools";
    azure = mkEnableOption "Enable Azure cloud tools";
    gcp = mkEnableOption "Enable GCP cloud tools";
  };

  config = mkMerge [
    # AWS
    (mkIf cfg.aws {
      environment.systemPackages = with pkgs; [
        awscli
      ];
    })
    # Azure
    (mkIf cfg.azure {
      environment.systemPackages = with pkgs; [
        azure-cli
      ];
    })
    # GCP
    (mkIf cfg.azure {
      environment.systemPackages = with pkgs; [
        google-cloud-sdk
      ];
    })
  ];
}
