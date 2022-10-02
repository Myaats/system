{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  mullvadConfig = config.modules.services.mullvad;
  mullvad-vpn = pkgs.mullvad-vpn;
in {
  options.modules.services.mullvad = {
    enable = mkEnableOption "enable the mullvad vpn client";
    alwaysRequireVpn = mkEnableOption "block the internet when not connected to the vpn";
    autoConnect = mkEnableOption "auto connect mullvad on startup";
    emergencyOnFail = mkEnableOption "go into emergency on start fail";
    localNetworkSharing = mkEnableOption "allow lan connections";
    tunnelProtocol = mkOption {
      type = types.enum ["wireguard" "openvpn"];
      default = "wireguard";
      description = "tunnel protocol";
    };
    location = mkOption {
      type = types.nullOr (types.enum ["no"]);
      default = "no";
      description = "default location";
    };
  };

  config = mkMerge [
    (mkIf mullvadConfig.enable {
      environment.systemPackages = [
        mullvad-vpn
      ];

      networking.wireguard.enable = true;
      networking.iproute2.enable = true;
      networking.firewall.checkReversePath = "loose";

      systemd.services.mullvad = {
        description = "Mullvad VPN daemon service";
        wants = ["network.target"];
        after = ["network-online.target" "systemd-resolved.service"];
        wantedBy = ["multi-user.target"];
        path = with pkgs; [iproute2 iputils];

        serviceConfig = {
          ExecStart = "${mullvad-vpn}/bin/mullvad-daemon -v --disable-stdout-timestamps";
          ExecStartPost = pkgs.writeShellScript "mullvad_setup" ''
            ${pkgs.coreutils}/bin/sleep 3
            ${mullvad-vpn}/bin/mullvad lan set ${
              if mullvadConfig.localNetworkSharing
              then "allow"
              else "block"
            }

            ${mullvad-vpn}/bin/mullvad relay set tunnel-protocol ${mullvadConfig.tunnelProtocol}
            ${
              if mullvadConfig.location != null
              then "${mullvad-vpn}/bin/mullvad relay set location ${mullvadConfig.location}"
              else ""
            }
            ${
              if mullvadConfig.autoConnect
              then "${mullvad-vpn}/bin/mullvad connect"
              else ""
            }

            ${mullvad-vpn}/bin/mullvad always-require-vpn set ${
              if mullvadConfig.alwaysRequireVpn
              then "on"
              else "off"
            }
            ${mullvad-vpn}/bin/mullvad auto-connect set ${
              if mullvadConfig.autoConnect
              then "on"
              else "off"
            }
          '';
          Restart = "always";
          RestartSec = 1;
          StartLimitBurst = 5;
          StartLimitIntervalSec = 20;
        };
        unitConfig = (
          if mullvadConfig.emergencyOnFail
          then {
            OnFailure = "emergency.target";
            OnFailureJobMode = "replace-irreversibly";
          }
          else {}
        );
      };
    })
  ];
}
