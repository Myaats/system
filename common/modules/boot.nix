{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.boot;
  kernel = config.boot.kernelPackages.kernel;
in {
  options.modules.boot = {
    # These are kernel modules that are built with patches and overriding the main kernel modules
    # This is an easier way to patch kernel modules without having to rebuild the kernel
    kernelModulePatches = mkOption {
      type = types.listOf (types.submodule {
        options = {
          name = mkOption {
            description = "Name of the patch";
            type = types.str;
          };
          patches = mkOption {
            description = "Patch files to apply to the kernel source tree";
            type = types.listOf types.anything;
          };
          modules = mkOption {
            description = "Modules to build and install";
            type = types.listOf types.str;
          };
        };
      });
      default = [];
      description = "List of kernel module patches to rebuild with the current kernel source tree";
    };
  };

  config = mkIf (cfg.kernelModulePatches != []) {
    boot.extraModulePackages = [
      # Override the current kernel
      (pkgs.stdenv.mkDerivation {
        name = "linux-modules-patched-${kernel.version}";
        # Copy the src
        src = kernel.src;
        # Add the existing kernel modules
        nativeBuildInputs = kernel.dev.moduleBuildDependencies;
        # Add the patches
        patches = concatLists (map (km: km.patches) cfg.kernelModulePatches);
        # Find the KDIR for the current kernel
        KDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
        # Build the kernel modules
        buildPhase = ''
          # Copy the module sources and add them to the new Makefile
          ${concatStringsSep "\n" (flatten (map (km: (map (m: let
              name = last (splitString "/" m);
            in ''
              echo "obj-m += ${name}.o" >> $TMP/Makefile
              ln -s $(realpath ${m}.c) $TMP/${name}.c
              if [ -f ${m}.h ]; then
                ln -s $(realpath ${m}.h) $TMP/${name}.h
              fi
            '')
            km.modules))
          cfg.kernelModulePatches))}

          # Build the modules
          make -C $KDIR M=$TMP modules
        '';
        # Install the kernel modules
        installPhase = concatStringsSep "\n" (flatten (map (km: (map (m: let
            name = last (splitString "/" m);
          in ''
            # Compress the kernel module
            xz $TMP/${name}.ko
            # Install it with the same permissions that NixOS uses
            install -vD -m0444 $TMP/${name}.ko.xz $out/lib/modules/${kernel.modDirVersion}/kernel/${m}.ko.xz
          '')
          km.modules))
        cfg.kernelModulePatches));

        # Higher priority than the actual kernel
        meta.priority = 0;
      })
    ];
  };
}
