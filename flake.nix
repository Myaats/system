{
  description = "Mats' NixOS configuration";

  inputs = {
    # Nixpkgs - NixOS Unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # NUR
    nur.url = "github:nix-community/NUR";
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Fenix - Rust toolchains and nightly
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nur,
    home-manager,
    fenix,
  } @ inputs: let
    lib = nixpkgs.lib;
    nurPkgs = system:
      import nur {
        pkgs = import nixpkgs {inherit system;};
        nurpkgs = import nixpkgs {inherit system;};
      };
    # Function to create a NixOS system for a device
    getDeviceProfile = system: path: (nixpkgs.legacyPackages.${system}.callPackage path {}).device.profile;
    mkNixosDevice = {
      system ? "x86_64-linux",
      device,
    }: let
      profile = getDeviceProfile system (./devices + "/${device}/configuration.nix");
    in
      lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit system inputs nixpkgs home-manager profile;
          nur = nurPkgs system;
          fenix = fenix.packages.${system};
          deviceArgs.hostName = device; # Pass the device name as hostname
        };

        modules = [
          ./common
          ./devices/${device}/configuration.nix
        ];
      };
  in {
    # Create NixOS configurations for all devices
    nixosConfigurations =
      lib.attrsets.mapAttrs'
      (device: _:
        lib.attrsets.nameValuePair device (mkNixosDevice {
          inherit device;
        }))
      (builtins.readDir ./devices);
  };
}
