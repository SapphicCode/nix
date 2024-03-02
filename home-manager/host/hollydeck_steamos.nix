# SteamOS configuration
{pkgs, ...}: {
  home.username = "deck";
  home.homeDirectory = "/home/deck";
  home.stateVersion = "23.05";

  services.syncthing.enable = true;

  imports = [
    ../profile/comfortable.nix
  ];
}
