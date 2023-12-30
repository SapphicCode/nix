{
  description = "Cassandra's everything flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    homeManager = {
      url = "path:./home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, homeManager, ... }: {
    inherit (homeManager) homeConfigurations;
  };
}
