{lib, ...}:
with lib; {
  imports = importNixFiles [
    ./development-tools
    ./hardware
  ];
}
