{...}: {
  nixpkgs.overlays = [
    (self: super:
      with super; {
        local = {
          mpv-inhibit-gnome = callPackage ./local/mpv-inhibit-gnome.nix {};
          tablet-osk = callPackage ./local/tablet-osk {};
          tas2563-fw = callPackage ./local/tas2563-fw.nix {};
        };
      })
  ];
}
