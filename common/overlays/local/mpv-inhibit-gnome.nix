{
  stdenv,
  fetchFromGitHub,
  pkgs,
  lib,
}:
stdenv.mkDerivation rec {
  name = "mpv_inhibit_gnome";
  version = "9069be0f15fa2c222d78a183d4aa1477d8a8f2cd";

  src = fetchFromGitHub {
    owner = "Guldoman";
    repo = "mpv_inhibit_gnome";
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-LSGg5gAQE2JpepBqhz6D6d3NlqYaU4bjvYf1F+oLphQ=";
  };

  buildInputs = with pkgs; [
    dbus
    mpv-unwrapped
  ];

  nativeBuildInputs = [
    pkgs.pkg-config
  ];

  installPhase = ''
    mkdir -p $out/share/mpv/scripts
    install -m 0755 "./lib/mpv_inhibit_gnome.so" $out/share/mpv/scripts
  '';

  passthru.scriptName = "mpv_inhibit_gnome.so";
}
