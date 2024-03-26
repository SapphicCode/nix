{
  description = "Cassandra's everything flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
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
        "sapphiccode@pandora" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages."x86_64-linux";
          modules = [./home-manager/host/pandora.nix];
        };
        "sapphiccode@hollydeck" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages."x86_64-linux";
          modules = [./home-manager/host/hollydeck_bazzite.nix];
        };
        "deck@hollydeck" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages."x86_64-linux";
          modules = [./home-manager/host/hollydeck_steamos.nix];
        };
      };

      templates.local-nixos = {
        path = ./template/nixos;
        description = "A local NixOS flake tracking this one.";
      };

      nixosModules = {
        openssh = ./nixos/module/openssh.nix;
        tailscale = ./nixos/module/tailscale.nix;
        profile_server = ./nixos/profile/server.nix;
        profile_desktop = ./nixos/profile/desktop.nix;
      };
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
        "generic_comfy" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable;
          modules = [
            ./home-manager/host/generic.nix
            ./home-manager/profile/comfortable.nix
          ];
        };
        "generic_minimal" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable;
          modules = [
            ./home-manager/host/generic.nix
            ./home-manager/profile/minimal.nix
          ];
        };

        "Maeve" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable;
          modules = [./home-manager/host/Maeve.nix];
        };
        "Clementine" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable;
          modules = [./home-manager/host/Clementine.nix];
        };
      };

      packages.nixosConfigurations = {
        "pandora" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {inherit unstable;};
          modules = [
            ./nixos/host/pandora/configuration.nix
            ./nixos/host/pandora/hardware-configuration.nix
            ./nixos/module/user/sapphiccode.nix
            ./nixos/module/openssh.nix
            ./nixos/module/tailscale.nix
          ];
        };
        "Clementine-PVM" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {inherit unstable;};
          modules = [
            ./nixos/host/Clementine-PVM/hardware-configuration.nix
            ./nixos/profile/desktop.nix
            ./nixos/module/vm-guest.nix
            ({...}: {
              networking.hostName = "Clementine-PVM";
            })
          ];
        };
      };
    });
}
