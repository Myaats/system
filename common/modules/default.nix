{lib, ...}:
with lib; {
  imports =
    importNixFiles [
      ./services
    ]
    ++ [
      ./boot.nix
    ];
}
