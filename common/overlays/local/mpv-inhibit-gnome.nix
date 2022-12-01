{
  stdenv,
  fetchFromGitHub,
  pkg-config,
  dbus,
  mpv-unwrapped
}:
stdenv.mkDerivation rec {
  pname = "mpv_inhibit_gnome";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "Guldoman";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LSGg5gAQE2JpepBqhz6D6d3NlqYaU4bjvYf1F+oLphQ=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dbus mpv-unwrapped ];

  passthru.scriptName = "mpv_inhibit_gnome.so";

  installPhase = ''
    install -D ./lib/mpv_inhibit_gnome.so $out/share/mpv/scripts
  '';
}
