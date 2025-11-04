{unstable, ...}: let
  lix = unstable.lixPackageSets.latest.lix;
in {
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix = {
    package = lix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["sapphiccode"];
    };
  };

  environment.systemPackages = [
    lix
  ];

  services.nix-daemon.enable = true;

  system.stateVersion = 6;
}
