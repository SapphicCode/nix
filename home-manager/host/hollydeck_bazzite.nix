# bazzite configuration
{pkgs, ...}: {
  home.username = "sapphiccode";
  home.homeDirectory = "/var/home/sapphiccode";
  home.stateVersion = "23.05";

  services.syncthing.enable = true;

  imports = [
    ../profile/comfortable.nix
  ];
}
