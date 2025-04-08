{unstable, ...}: {
  nixpkgs.hostPlatform = "aarch64-darwin";
  services.nix-daemon.enable = true;
  nix.package = unstable.lix;
  system.stateVersion = 5;
}
