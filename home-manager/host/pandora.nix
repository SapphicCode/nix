{...}: {
  home.username = "sapphiccode";
  home.homeDirectory = "/home/sapphiccode";
  home.stateVersion = "23.05";

  services.syncthing.enable = true;

  imports = [
    ../profile/graphical.nix
  ];
}
