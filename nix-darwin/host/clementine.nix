{...}: {
  imports = [
    ../profile/default.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.settings.trusted-users = ["sapphiccode"];
  system.stateVersion = 5;
}
