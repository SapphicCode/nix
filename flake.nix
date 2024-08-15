{
  description = "Cassandra's everything flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/e03dc36a26ddfe0ea823cdf2b5ed2dd5d23b0bf9";

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
      };

      legacyPackages.nixosConfigurations = {
        "pandora" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {inherit unstable;};
          modules = [
            ./nixos/host/pandora/hardware-configuration.nix
            ./nixos/profile/desktop_${system}.nix
            ./nixos/module/gnome.nix
            ./nixos/module/framework-13.nix
            ({config, ...}: {
              networking.hostName = "pandora";
              networking.hostId = "94ad2a33";
              boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
            })
          ];
        };
        "blahaj" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {inherit unstable;};
          modules = [
            ./nixos/host/blahaj/hardware-configuration.nix
            ./nixos/module/boot/systemd-boot.nix
            ./nixos/profile/server_${system}.nix
            ./nixos/module/user/hex.nix
            ./nixos/module/user/chaos.nix
            ({...}: {
              networking.hostName = "blahaj";
              networking.hostId = "ef32a18b";
              services.qemuGuest.enable = true;

              users.users.sapphiccode.linger = true;
              users.users.hex.linger = true;

              networking.firewall.allowedTCPPortRanges = [
                {
                  from = 15080;
                  to = 15100;
                }
              ];
            })
          ];
        };
      };

      packages.thorium-browser = pkgs.callPackage ./packages/thorium-browser.nix {};
    });
}
