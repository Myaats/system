{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.development-tools.android = mkEnableOption "Enable Android development-tools";

  config = mkIf config.modules.development-tools.android {
    # Android studio, tools and flutter
    environment.systemPackages = with pkgs; [
      apktool
      android-studio
      android-tools
      flutter
      dart
    ];

    # Accept the license
    nixpkgs.config.android_sdk.accept_license = true;

    # Enable adb
    programs.adb.enable = true;
    users.users.mats.extraGroups = ["adbusers"];
    # Setup CHOME_EXECUTABLE for flutter
    environment.variables.CHROME_EXECUTABLE = "${pkgs.ungoogled-chromium}/bin/chromium";

    # Fix DN2103 not passing through udev
    services.udev.extraRules = ''
      ATTR{idVendor}=="22d9", ATTR{idProduct}=="2765", SYMLINK+="android_adb", MODE="0660", GROUP="adbusers", TAG+="uaccess", SYMLINK+="android", SYMLINK+="android%n"
    '';

    # Add dart pub executables to path
    home.config = {config, ...}: {
      programs.zsh.initExtra = ''
        export PATH=${config.home.homeDirectory}/.pub-cache/bin:$PATH
      '';
    };
  };
}
