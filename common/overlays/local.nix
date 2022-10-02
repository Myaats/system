{...}: {
  nixpkgs.overlays = [
    (self: super:
      with super; {
        local = {
          steamos-devkit = callPackage ./steamos-devkit.nix {};
        };
      })
  ];
}
