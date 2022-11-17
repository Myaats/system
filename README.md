# Mats' NixOS configuration

## Structure
* `common` - Common configuration shared for all devices
    * `assets` - Static content like images and binaries
    * `modules` - Re-usable modules across all profiles
    * `overlays` - Nixpkgs overrides and additional packages
    * `profiles` - Device profiles (e.g., desktop, laptop)
    * `users` - User accounts on my devices
* `devices` - Device specific configuration
* `lib` - Overlay for *lib* in nixpkgs 

## system.sh

This repo contains `system.sh` which contains a few subcommands. Most commands just call `nixos-rebuild` with the flake and other arguments set. There is also `format` to call `alejandra` for formatting.

```
Usage: system.sh <subcommand> [options]
Subcommands:
    boot        Build generation and add to bootloader
    build       Build the system
    dry-build   Run a dry build for the system
    format      Format all nix expressions
    switch      Build and switch to generation

For help with each subcommand run:
system.sh <subcommand> --help
```