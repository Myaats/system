{
  config,
  lib,
  ...
}:
with lib; {
  imports = [
    # Inherit desktop profile
    ../desktop
  ];
}
