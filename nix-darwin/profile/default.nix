{unstable, ...}: let
  lix = unstable.lixPackageSets.latest.lix;
in {
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix = {
    enable = true;
    package = lix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["sapphiccode"];
    };
  };

  environment.systemPackages = [
    lix
  ];

  system.stateVersion = 6;
}
