{
  config,
  lib,
  options,
  pkgs,
  inputs,
  ...
}:
with lib; {
  imports = [
    (import "${inputs.home-manager}/nixos")
  ];

  options.home-manager.mainUsers = mkOption {
    type = types.listOf types.str;
    example = ["root"];
    default = [];
    description = "Main users for this system";
  };
  options.home-manager.config = mkOption {
    type = options.home-manager.users.type.functor.wrapped;
    default = {};
    description = "Home-manager configuration to be used for all main users";
  };

  config = {
    home-manager.users = mkMerge (
      flip map config.home-manager.mainUsers (
        user: {
          ${user} = mkAliasDefinitions options.home-manager.config;
        }
      )
    );

    home-manager.config = {
      inputs,
      config,
      ...
    }: {
      home.stateVersion = "22.11";

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
      config.home-manager.mainUsers;
  };
}
