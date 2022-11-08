{lib, ...}:
with lib; {
  imports = importNixFiles [
    ./services
  ];
}
