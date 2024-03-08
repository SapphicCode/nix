{
  description = "A local NixOS configuration flake with universe modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11"; # upgrade system version here
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    universe.url = "git+https://git.sapphicco.de/SapphicCode/universe.git";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
    universe,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      config = {
        allowUnfree = true;
      };
      pkgs = import nixpkgs {inherit system config;};
      unstable = import nixpkgs-unstable {inherit system config;};
    in {
      packages.nixosConfigurations."example-hostname" = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs = {inherit unstable;};
        modules = [
          ./hardware-configuration.nix
          universe.nixosModules.exampleModule
        ];
      };
    });
}
