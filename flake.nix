{
  description = "Cassandra's everything flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/4b8dce39995a55af3d703b08bcc372c6537a2540";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
    home-manager,
    nix-darwin,
    ...
  }:
    {
      templates.local-nixos = {
        path = ./template/nixos;
        description = "A local NixOS flake tracking this one.";
      };

      nixosModules = {
        openssh = ./nixos/module/openssh.nix;
        tailscale = ./nixos/module/tailscale.nix;
        printing = ./nixos/module/printing.nix;
        user_automata = ./nixos/users/user/automata.nix;
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
      overlays = [
        (final: prev: {
          numbat = prev.numbat.overrideAttrs (self: {
            meta = self.meta // {broken = false;};
          });
          beets = prev.beets.overrideAttrs (self: {
            patches =
              (self.patches or [])
              ++ [
                # use relative paths to music in database:
                # https://github.com/beetbox/beets/issues/133#issuecomment-1953558839
                (prev.fetchpatch {
                  url = "https://github.com/artemist/beets/commit/a53fe00fe6026caf223d905960891cda60251ce9.patch";
                  hash = "sha256-6whmjHmCeIxrzTgc1JhHT0GNaBoQT5B9Fi2j5st7XgY=";
                })
              ];
          });
        })
      ];
      pkgs = import nixpkgs {
        inherit system config;
        overlays =
          [
            self.overlays.thorium-browser
          ]
          ++ overlays;
      };
      unstable = import nixpkgs-unstable {
        inherit system config overlays;
      };
    in {
      formatter = pkgs.alejandra;

      legacyPackages.homeConfigurations = {
        "Maeve" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable;
          extraSpecialArgs = {stable = pkgs;};
          modules = [./home-manager/host/Maeve.nix];
        };
        "Clementine" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable;
          extraSpecialArgs = {stable = pkgs;};
          modules = [./home-manager/host/Clementine.nix];
        };
        "pandora" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable;
          extraSpecialArgs = {stable = pkgs;};
          modules = [./home-manager/host/pandora.nix];
        };
        "Pandora" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable;
          extraSpecialArgs = {stable = pkgs;};
          modules = [./home-manager/host/pandora_wsl.nix];
        };
        "hollydeck" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable;
          extraSpecialArgs = {stable = pkgs;};
          modules = [./home-manager/host/hollydeck_steamos.nix];
        };
        "blahaj" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable;
          extraSpecialArgs = {stable = pkgs;};
          modules = [./home-manager/host/blahaj.nix];
        };

        "generic_minimal" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable;
          extraSpecialArgs = {stable = pkgs;};
          modules = [
            ./home-manager/host/generic.nix
            ./home-manager/profile/minimal.nix
          ];
        };
        "generic_comfy" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable;
          extraSpecialArgs = {stable = pkgs;};
          modules = [
            ./home-manager/host/generic.nix
            ./home-manager/profile/comfortable.nix
          ];
        };
        "generic_everything" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable;
          extraSpecialArgs = {stable = pkgs;};
          modules = [
            ./home-manager/host/generic.nix
            ./home-manager/profile/everything.nix
          ];
        };
      };

      legacyPackages.nixosConfigurations = {
        "pandora" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {inherit unstable;};
          modules = [
            ./nixos/host/pandora/hardware-configuration.nix
            ./nixos/profile/desktop_${system}.nix
            ./nixos/module/plasma6.nix
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
          modules = [./nixos/host/blahaj];
        };
        "eule" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {inherit unstable;};
          modules = [./nixos/host/eule.nix];
        };
      };

      legacyPackages.darwinConfigurations = {
        Maeve = nix-darwin.lib.darwinSystem {
          modules = [./nix-darwin/host/maeve.nix];
          specialArgs = {inherit unstable;};
        };
        Clementine = nix-darwin.lib.darwinSystem {
          modules = [./nix-darwin/host/clementine.nix];
          specialArgs = {inherit unstable;};
        };
      };

      packages.thorium-browser = pkgs.callPackage ./packages/thorium-browser.nix {};
    });
}
