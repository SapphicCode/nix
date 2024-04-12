{pkgs, ...}: {
  home.username = "cassandra.beelen";
  home.homeDirectory = "/Users/cassandra.beelen";
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    bash
    coreutils
    curl
    gnugrep
    gnused
    lima
  ];

  imports = [
    ../profile/everything.nix
    ../profile/fonts.nix
  ];
}
