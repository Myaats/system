{profile, ...}: {
  imports = [
    ./assets
    ./modules
    ./overlays
    ./profiles/base.nix
    ./profiles/${profile}
    ./users
    ./boot.nix
    ./device.nix
    ./i18n.nix
    ./nix.nix
  ];
}
