{pkgs, ...}: {
  home.username = "cassandra.beelen";
  home.homeDirectory = "/Users/cassandra.beelen";
  home.stateVersion = "23.05";

  imports = [
    ../profile/everything.nix
    ../module/fonts.nix
    ../module/macos.nix
  ];
}
