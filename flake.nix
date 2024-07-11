{
  description = "Cassandra's everything flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/67ab30a1aac28c793dc119a74ceab95643a330f8";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0-rc1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    lix-module,
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
        lix-cache = {...}: {
          nix.settings.extra-substituters = ["https://cache.lix.systems"];
          nix.settings.trusted-public-keys = ["cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="];
        };
      };

      overlays = {
        thorium-browser = final: prev: {
          thorium-browser = final.callPackage ./packages/thorium-browser.nix {};
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      config = {
        allowUnfree = true;
        permittedInsecurePackages = ["electron-25.9.0"]; # obsidian
      };
      pkgs = import nixpkgs {
        inherit system config;
        overlays = [
          self.overlays.thorium-browser
        ];
      };
      unstable = import nixpkgs-unstable {inherit system config;};
    in {
      formatter = pkgs.alejandra;

      legacyPackages.homeConfigurations = {
        "generic_minimal" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable;
          modules = [
            ./home-manager/host/generic.nix
            ./home-manager/profile/minimal.nix
          ];
        };
        "generic_comfy" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable;
          modules = [
            ./home-manager/host/generic.nix
            ./home-manager/profile/comfortable.nix
          ];
        };
        "generic_everything" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable;
          modules = [
            ./home-manager/host/generic.nix
            ./home-manager/profile/everything.nix
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

      legacyPackages.nixosConfigurations = {
        "pandora" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {inherit unstable;};
          modules = [
            ./nixos/host/pandora/hardware-configuration.nix
            ./nixos/profile/desktop.nix
            ./nixos/module/gnome.nix
            ./nixos/module/framework-13.nix
            ({config, ...}: {
              networking.hostName = "pandora";
              networking.hostId = "94ad2a33";
              boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
            })
          ];
        };
        "cyberdemon" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {inherit unstable;};
          modules = [
            ./nixos/host/cyberdemon/hardware-configuration.nix
            ./nixos/profile/desktop_${system}.nix
            ./nixos/module/gnome.nix
            ./nixos/module/user/aurelia.nix
            (_: {
              networking.hostName = "cyberdemon";
              networking.hostId = "93515df2";
            })
          ];
        };
        "Clementine-PVM" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {inherit unstable;};
          modules = [
            ./nixos/host/Clementine-PVM/hardware-configuration.nix
            ./nixos/profile/desktop_${system}.nix
            ./nixos/module/plasma6.nix
            ./nixos/module/vm-guest.nix
            ({...}: {
              networking.hostName = "Clementine-PVM";
            })
          ];
        };
        "blahaj" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {inherit unstable;};
          modules = [
            ./nixos/host/blahaj/hardware-configuration.nix
            ./nixos/profile/server_${system}.nix
            ({...}: {
              networking.hostName = "blahaj";
              networking.hostId = "ef32a18b";
              services.qemuGuest.enable = true;
            })
          ];
        };
      };

      packages.thorium-browser = pkgs.callPackage ./packages/thorium-browser.nix {};
    });
}
