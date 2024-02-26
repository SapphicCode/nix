{
  description = "Cassandra's everything flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    home-manager,
    ...
  }:
    {
      homeConfigurations = {
        "sapphiccode@Maeve" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-darwin";
          modules = [./home-manager/host/Maeve.nix];
        };
        "sapphiccode@Beauvoir" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-darwin";
          modules = [./home-manager/host/Beauvoir.nix];
        };
        "sapphiccode@pandora" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [./home-manager/host/pandora.nix];
        };
        "sapphiccode@hollydeck" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [./home-manager/host/hollydeck_bazzite.nix];
        };
        "deck@hollydeck" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [./home-manager/host/hollydeck_steamos.nix];
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      inherit system;
    in {
      formatter = pkgs.alejandra;
      packages.homeConfigurations = {
        "generic-server" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [./home-manager/host/generic-server.nix];
        };
      };
    });
}
