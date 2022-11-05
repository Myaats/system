{...}: {
  nixpkgs.overlays = [
    (self: super:
      with super; {
        local = {
          mpv-inhibit-gnome = callPackage ./local/mpv-inhibit-gnome.nix {};
          steamos-devkit = callPackage ./local/steamos-devkit.nix {};
          tablet-osk = callPackage ./local/tablet-osk {};
        };
      })
  ];
}
