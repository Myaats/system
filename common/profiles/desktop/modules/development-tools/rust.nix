{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.development-tools.rust = mkEnableOption "Enable Rust development-tools";

  config = mkIf config.modules.development-tools.rust {
    environment.systemPackages = with pkgs; [
      rustup
      trunk
      wasm-bindgen-cli
    ];

    home-manager.config = {config, ...}: {
      programs.zsh.initExtra = ''
        export PATH=${config.home.homeDirectory}/.cargo/bin:$PATH
      '';
    };
  };
}
