{lib, ...}:
with lib; {
  options.assets = mkOption {
    type = types.attrs;
    default = {};
    description = "Assets inside common/assets/";
  };

  # It is faster to just hardcode these files.
  config.assets = {
    app-grid = ./app-grid.svg;
    bg = ./bg.png;
  };
}
