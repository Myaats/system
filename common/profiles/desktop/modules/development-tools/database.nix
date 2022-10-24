{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.development-tools.database;
in {
  options.modules.development-tools.database = {
    postgres = mkEnableOption "Enable postgres (dev)";
    redis = mkEnableOption "Enable redis (dev)";
  };

  config = mkMerge [
    # Postgres
    (mkIf cfg.postgres {
      services.postgresql = {
        enable = true;
        package = pkgs.postgresql_15;
        enableTCPIP = false;
        authentication = pkgs.lib.mkOverride 10 ''
          local all all trust
          host all all 127.0.0.1/32 trust
          host all all ::1/128 trust
          host all all 0.0.0.0/0 reject
        '';
        # Change
        initialScript = pkgs.writeText "backend-initScript" ''
          ALTER USER postgres WITH PASSWORD 'postgres';
        '';
      };
    })
    # Redis
    (mkIf cfg.redis {
      services.redis.servers.dev.enable = true;
    })
  ];
}
