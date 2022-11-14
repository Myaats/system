{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.development-tools.texlive = mkEnableOption "Enable Texlive and related software";

  config = mkIf config.modules.development-tools.texlive {
    environment.systemPackages = with pkgs; [
      tectonic
      texlive.combined.scheme-full
      gnome-latex
    ];
  };
}
