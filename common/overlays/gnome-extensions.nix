{...}: {
  nixpkgs.overlays = [
    (self: super:
      with super; {
        gnomeExtensions = with gnomeExtensions;
          gnomeExtensions
          // {
          };
      })
  ];
}
