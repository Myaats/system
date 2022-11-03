{...}: {
  nixpkgs.overlays = [
    (self: super:
      with super; {
        local = {
          mpv-inhibit-gnome = callPackage ./mpv-inhibit-gnome.nix {};
          steamos-devkit = callPackage ./steamos-devkit.nix {};
          tablet-osk = callPackage ./local/tablet-osk {};
        };
      })
  ];
}
