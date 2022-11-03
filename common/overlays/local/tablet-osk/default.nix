{
  pkgs,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  name = "tablet-osk";
  version = "0.1.0";
  cargoLock.lockFile = ./Cargo.lock;
  src = ./.;
  nativeBuildInputs = [pkgs.pkg-config];
  buildInputs = with pkgs; [udev libinput];
}
