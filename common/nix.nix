{inputs, ...}: {
  nix = {
    settings = {
      # Enable experimental nix command and flakes
      experimental-features = ["nix-command" "flakes"];
      # Set allowed and trusted users
      allowed-users = ["@wheel"];
      trusted-users = ["root" "@wheel"];
    };
    # Set some nix registries to use flake input
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      nur.flake = inputs.nur;
    };
    # Set some nix paths
    nixPath = ["nixpkgs=${inputs.nixpkgs}" "nur=${inputs.nur}"];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
