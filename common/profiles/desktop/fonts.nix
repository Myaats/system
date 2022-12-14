{pkgs, ...}: {
  fonts.fontconfig.hinting = {
    autohint = true;
    enable = true;
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override {
        fonts = ["FiraCode" "DroidSansMono" "DejaVuSansMono" "Noto" "Inconsolata" "CascadiaCode" "BitstreamVeraSansMono"];
      })
      liberation_ttf
      siji
      unifont
      corefonts
      vistafonts
      source-sans-pro
      source-code-pro
    ];
  };
}
