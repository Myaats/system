{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.development-tools.nix = mkEnableOption "Enable nix development-tools";

  config = mkIf config.modules.development-tools.nix {
    environment.systemPackages = with pkgs; [
      alejandra
      cachix
      deploy-rs
      nixpkgs-lint
      nixpkgs-review
      nixpkgs-fmt
      nix-index
      nix-prefetch-git
    ];

    services.lorri.enable = true;
  };
}
