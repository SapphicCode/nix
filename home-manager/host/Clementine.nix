{pkgs, ...}: {
  home.username = "sapphiccode";
  home.homeDirectory = "/Users/sapphiccode";
  home.stateVersion = "23.05";

  services.syncthing.enable = true;

  imports = [
    ../profile/everything.nix
    ../module/macos.nix
  ];
}
