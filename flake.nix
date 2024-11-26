{
  description = "Cassandra's everything flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/76c7c2dd88be617a8a9fdda78f2845eafbb40088";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pkg-mergiraf = {
      url = "git+https://codeberg.org/mergiraf/mergiraf";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
    home-manager,
    nix-darwin,
    pkg-mergiraf,
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
          mergiraf = pkg-mergiraf.packages.${system}.mergiraf;
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
          modules = [
            ./nixos/host/blahaj/hardware-configuration.nix
            ./nixos/host/blahaj/containers.nix
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

              programs.nix-ld.enable = true;

              services.k3s = {
                enable = true;
                role = "server";
                extraFlags = "--tls-san=blahaj.sapphiccode.net --tls-san=blahaj-ng.atlas-ide.ts.net";
              };

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

      legacyPackages.darwinConfigurations = {
        Maeve = nix-darwin.lib.darwinSystem {
          modules = [./nix-darwin/host/maeve.nix];
          specialArgs = {inherit unstable;};
        };
      };

      packages.thorium-browser = pkgs.callPackage ./packages/thorium-browser.nix {};
    });
}
