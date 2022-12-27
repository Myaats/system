{...}: {
  nixpkgs.overlays = [
    (self: super:
      with super; {
        local = {
          tablet-osk = callPackage ./local/tablet-osk {};
          tas2563-fw = callPackage ./local/tas2563-fw.nix {};
        };
      })
  ];
}
