{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.development-tools.cpp = mkEnableOption "Enable C/C++ development-tools";

  config = mkIf config.modules.development-tools.cpp {
    environment.systemPackages = with pkgs; [
      # GCC/GNU stuff
      gcc_multi
      binutils
      # Clang
      (lowPrio clang_multi) # Let GCC get priority for now
      clang-tools
      clang-analyzer
      # Build tools
      gnumake
      meson
      ninja
      cmake
      m4
      flex
      bison
    ];
  };
}
