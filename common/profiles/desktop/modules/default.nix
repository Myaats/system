{lib, ...}:
with lib; let
  importPaths = paths:
    flatten
    (map
      (path:
        mapAttrsToList (name: _: path + "/${name}")
        (filterAttrs (name: _: hasSuffix ".nix" name)
          (builtins.readDir path)))
      paths);
in {
  imports = importPaths [
    ./development-tools
  ];
}
