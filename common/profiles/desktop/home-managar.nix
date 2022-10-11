{
  config,
  lib,
  options,
  pkgs,
  inputs,
  ...
}:
with lib; let
  stateVersion = config.system.stateVersion;
in {
  imports = [
    (import "${inputs.home-manager}/nixos")
  ];

  # Extend home-manager settings
  options = {
    home = {
      mainUsers = mkOption {
        type = types.listOf types.str;
        example = ["root"];
        default = [];
        description = "Main users for this system";
      };

      config = mkOption {
        type = options.home-manager.users.type.functor.wrapped;
        default = {};
        description = "Home-manager configuration to be used for all main users";
      };

      users = mkOption {
        type = types.attrsOf options.home-manager.users.type.functor.wrapped;
        default = {};
        description = "Home-manager per user configuration";
      };
    };
  };

  config = {
    home-manager.users =
      (mkMerge (
        flip map config.home.mainUsers (
          user: {
            ${user} = mkAliasDefinitions options.home.config;
          }
        )
      ))
      // config.home.users;

    home.config = {
      inputs,
      config,
      ...
    }: {
      # Use the system stateVersion for home-manager
      home.stateVersion = stateVersion;

      # Absolutely proprietary
      nixpkgs.config.allowUnfree = true;

      # Get rid of channels
      home.activation.eliminateChannelsRoot = config.lib.dag.entryAfter ["writeBoundary"] ''
        rm -f $HOME/.nix-channels
        rm -rf $HOME/.nix-defexpr
        ln -sf ${inputs.nixpkgs} $HOME/.nix-defexpr
      '';
    };

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = {inherit inputs;};

    assertions =
      map
      (
        user: {
          assertion = builtins.hasAttr user config.users.users;
          message = "The main user ${user} has to exist";
        }
      )
      config.home.mainUsers;
  };
}
