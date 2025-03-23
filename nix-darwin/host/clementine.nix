{
  pkgs,
  unstable,
  ...
}: {
  nixpkgs.hostPlatform = "aarch64-darwin";
  services.nix-daemon.enable = true;
  nix.package = unstable.lix;
  nix.settings.trusted-users = ["sapphiccode"];
  system.stateVersion = 5;
}
