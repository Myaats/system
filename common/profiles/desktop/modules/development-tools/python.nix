{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.development-tools.python = mkEnableOption "Enable Python development-tools";

  config = mkIf config.modules.development-tools.python {
    environment.systemPackages = with pkgs; [
      # Python 3
      (python310Full.withPackages (p: with p; [pip setuptools pkgconfig]))
      pipenv
    ];
  };
}
