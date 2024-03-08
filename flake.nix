{
  description = "Cassandra's everything flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
    home-manager,
    ...
  }:
    {
      homeConfigurations = {
        "sapphiccode@Maeve" = home-manager.lib.homestableManagerConfiguration {
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

      templates.local-nixos = {
        path = ./template/nixos;
        description = "A local NixOS flake tracking this one.";
      };

      nixosModules.pandora = ./nixos/host/pandora/configuration.nix;
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      config = {
        allowUnfree = true;
        permittedInsecurePackages = ["electron-25.9.0"]; # obsidian
      };
      pkgs = import nixpkgs {inherit system config;};
      unstable = import nixpkgs-unstable {inherit system config;};
    in {
      formatter = pkgs.alejandra;

      packages.homeConfigurations = {
        "generic-server" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [./home-manager/host/generic-server.nix];
        };
      };

      packages.nixosConfigurations = {
        pandora = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {inherit unstable;};
          modules = [
            self.nixosModules.pandora
            ./nixos/host/pandora/hardware-configuration.nix
          ];
        };
      };
    });
}
