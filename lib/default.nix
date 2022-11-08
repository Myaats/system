pkgs:
with pkgs.lib;
  {
    # Import all the nix files of the directory in the paths list
    importNixFiles = paths:
      flatten
      (map
        (path:
          mapAttrsToList (name: _: path + "/${name}")
          (filterAttrs (name: _: hasSuffix ".nix" name)
            (builtins.readDir path)))
        paths);
  }
  // (import ./json.nix pkgs)
